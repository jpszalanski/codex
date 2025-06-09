# Codex IoT Example

This repository provides a simple Python script that publishes sensor data to **AWS IoT** and stores the same data in **Amazon DynamoDB**.

## Files

- `iot/sensor_device.py` - Example script that generates fake sensor readings, publishes them over MQTT and writes them to DynamoDB.

## Requirements

- Python 3
- `aws-iot-device-sdk-python-v2` and `boto3`
- AWS IoT certificates and endpoint
- DynamoDB table already created

## Usage

Export the following environment variables with your configuration:

```
export AWS_IOT_ENDPOINT="xxxxxxxxxxxxx-ats.iot.us-east-1.amazonaws.com"
export AWS_IOT_CERT="/path/to/certificate.pem.crt"
export AWS_IOT_KEY="/path/to/private.pem.key"
export AWS_IOT_CA="/path/to/AmazonRootCA1.pem"
export AWS_IOT_CLIENT_ID="device001"
export AWS_IOT_TOPIC="sensors/data"
export AWS_DYNAMO_TABLE="SensorData"
export AWS_REGION="us-east-1"
```

Install the dependencies and run the script:

```
pip install aws-iot-device-sdk-python-v2 boto3
python3 iot/sensor_device.py
```

The script will generate and send a sample payload every five seconds.
