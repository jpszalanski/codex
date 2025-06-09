# Codex IoT Example

Este repositório contém um exemplo simples de código em Python para conectar sensores ao **AWS IoT** e persistir dados no **Amazon DynamoDB**.

## Arquivos

- `iot/sensor_device.py` &mdash; Script de exemplo que gera dados fictícios de sensores, publica em um tópico MQTT no AWS IoT e grava os mesmos dados em uma tabela DynamoDB.

## Requisitos

- Python 3
- Bibliotecas `aws-iot-device-sdk-python-v2` e `boto3`
- Certificados e endpoint do AWS IoT
- Tabela DynamoDB já criada

## Uso

Edite as variáveis em `iot/sensor_device.py` preenchendo:

- `endpoint` &mdash; Endpoint do seu AWS IoT Core
- `cert_path`, `key_path` e `ca_path` &mdash; Caminhos para seus certificados
- `table_name` e `region_name` da tabela DynamoDB

Instale as dependências com:

```bash
pip install aws-iot-device-sdk-python-v2 boto3
```

Depois execute:

```bash
python3 iot/sensor_device.py
```

O script irá publicar e armazenar um conjunto de dados de exemplo a cada 5 segundos.
