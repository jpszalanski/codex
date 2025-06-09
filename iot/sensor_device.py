import json
import time
import random
from dataclasses import dataclass
from awscrt import mqtt
from awsiot import mqtt_connection_builder
import boto3

def get_sensor_payload(sensor_id: str) -> dict:
    """Generate a fake sensor payload for demonstration."""
    return {
        "sensor_id": sensor_id,
        "timestamp": int(time.time()),
        "temperature": round(random.uniform(20.0, 30.0), 2),
        "humidity": round(random.uniform(30.0, 60.0), 2),
    }


@dataclass
class AWSIoTConfig:
    client_id: str
    endpoint: str
    cert_path: str
    key_path: str
    ca_path: str
    topic: str


@dataclass
class DynamoConfig:
    table_name: str
    region_name: str


def connect_iot(config: AWSIoTConfig):
    connection = mqtt_connection_builder.mtls_from_path(
        endpoint=config.endpoint,
        port=8883,
        cert_filepath=config.cert_path,
        pri_key_filepath=config.key_path,
        client_id=config.client_id,
        ca_filepath=config.ca_path,
        clean_session=False,
        keep_alive_secs=30,
    )
    connection.connect().result()
    return connection


def connect_dynamo(config: DynamoConfig):
    session = boto3.session.Session()
    return session.resource("dynamodb", region_name=config.region_name).Table(config.table_name)


def publish_and_store(sensor_id: str, iot_client, table, topic: str):
    payload = get_sensor_payload(sensor_id)
    iot_client.publish(topic=topic, payload=json.dumps(payload), qos=mqtt.QoS.AT_LEAST_ONCE)
    table.put_item(Item=payload)
    print(f"Published and stored: {payload}")


if __name__ == "__main__":
    SENSOR_ID = "sensor-1"

    iot_config = AWSIoTConfig(
        client_id="device001",
        endpoint="YOUR_ENDPOINT.amazonaws.com",
        cert_path="/path/to/certificate.pem.crt",
        key_path="/path/to/private.pem.key",
        ca_path="/path/to/AmazonRootCA1.pem",
        topic="sensors/data",
    )

    dynamo_config = DynamoConfig(
        table_name="SensorData",
        region_name="us-east-1",
    )

    iot_client = connect_iot(iot_config)
    dynamo_table = connect_dynamo(dynamo_config)

    try:
        while True:
            publish_and_store(SENSOR_ID, iot_client, dynamo_table, iot_config.topic)
            time.sleep(5)
    except KeyboardInterrupt:
        print("Stopping device...")
        iot_client.disconnect().result()
