import json
import os
import time
import random
from dataclasses import dataclass
from awscrt import mqtt
from awsiot import mqtt_connection_builder
import boto3


def build_payload(sensor_id: str) -> dict:
    """Return a fake sensor payload."""
    return {
        "sensor_id": sensor_id,
        "timestamp": int(time.time()),
        "temperature": round(random.uniform(20.0, 30.0), 2),
        "humidity": round(random.uniform(30.0, 60.0), 2),
    }


@dataclass
class IoTConfig:
    endpoint: str
    cert: str
    key: str
    ca: str
    client_id: str
    topic: str


@dataclass
class DynamoConfig:
    table_name: str
    region: str


def mqtt_connect(cfg: IoTConfig):
    connection = mqtt_connection_builder.mtls_from_path(
        endpoint=cfg.endpoint,
        port=8883,
        cert_filepath=cfg.cert,
        pri_key_filepath=cfg.key,
        client_id=cfg.client_id,
        ca_filepath=cfg.ca,
        clean_session=False,
        keep_alive_secs=30,
    )
    connection.connect().result()
    return connection


def dynamo_table(cfg: DynamoConfig):
    session = boto3.session.Session()
    return session.resource("dynamodb", region_name=cfg.region).Table(cfg.table_name)


def publish_loop(sensor_id: str, mqtt_client, table, topic: str):
    while True:
        payload = build_payload(sensor_id)
        mqtt_client.publish(topic=topic, payload=json.dumps(payload), qos=mqtt.QoS.AT_LEAST_ONCE)
        table.put_item(Item=payload)
        print(f"Published and stored: {payload}")
        time.sleep(5)


if __name__ == "__main__":
    iot_cfg = IoTConfig(
        endpoint=os.environ["AWS_IOT_ENDPOINT"],
        cert=os.environ["AWS_IOT_CERT"],
        key=os.environ["AWS_IOT_KEY"],
        ca=os.environ["AWS_IOT_CA"],
        client_id=os.environ.get("AWS_IOT_CLIENT_ID", "device001"),
        topic=os.environ.get("AWS_IOT_TOPIC", "sensors/data"),
    )

    dynamo_cfg = DynamoConfig(
        table_name=os.environ["AWS_DYNAMO_TABLE"],
        region=os.environ.get("AWS_REGION", "us-east-1"),
    )

    mqtt_client = mqtt_connect(iot_cfg)
    table = dynamo_table(dynamo_cfg)

    try:
        publish_loop("sensor-1", mqtt_client, table, iot_cfg.topic)
    except KeyboardInterrupt:
        print("Stopping device...")
        mqtt_client.disconnect().result()
