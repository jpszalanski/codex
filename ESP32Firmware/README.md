# ESP32 Smart Plant Pot Firmware

This firmware reads environmental values from several sensors connected to an ESP32 board and displays them on a 1.8" ST7735 screen. It also publishes sensor values every hour (at minute 1) to AWS IoT so they can be persisted to DynamoDB via an IoT rule.

## Features

- **Sensors**
  - Capacitive soil moisture sensor (analog pin 34)
  - AHT10 temperature and humidity sensor over I2C
  - LDR for ambient light (analog pin 35)
- **Display**: ST7735 1.8" color display
- **Data Upload**: Publishes JSON to AWS IoT every hour when the minute equals 1. Configure an IoT rule to store these messages in DynamoDB.
- **Time**: Obtains current time via NTP to schedule hourly uploads.
- **Provisioning**: Starts in Access Point mode when no Wi-Fi credentials are stored so you can send them from the mobile app.

## Usage

1. Install libraries for `Adafruit_ST7735`, `Adafruit_GFX`, `Adafruit_AHTX0` and `AWS_IOT` via the Arduino Library Manager.
2. Build and flash the sketch to an ESP32 using the Arduino IDE or PlatformIO.
3. On first boot the device creates an AP called **SmartPotSetup**. Connect to it and POST your Wi-Fi credentials to `http://192.168.4.1/wifi`.
4. The credentials are stored in NVS and used automatically on subsequent boots. Configure the AWS IoT endpoint, client ID and certificates in `ESP32SmartPlantPot.ino`.

Sensor readings are refreshed every second on the display. Data will be published to AWS IoT once per hour.

## Hardware wiring

As ligacoes de todos os sensores e do display estao documentadas em
[`HardwareConnections.md`](HardwareConnections.md), que inclui um diagrama
em formato Mermaid exibindo os pinos utilizados.
