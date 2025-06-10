# ESP32 Smart Plant Pot Firmware

This firmware reads environmental values from several sensors connected to an ESP32 board and displays them on a 1.8" ST7735 screen. It also posts sensor values once per hour (at minute 1) to a DynamoDB-backed endpoint.

## Features

- **Sensors**
  - Capacitive soil moisture sensor (analog pin 34)
  - AHT10 temperature and humidity sensor over I2C
  - LDR for ambient light (analog pin 35)
- **Display**: ST7735 1.8" color display
- **Data Upload**: Sends JSON data to a web API (such as an AWS API Gateway backed by DynamoDB) every hour when the minute equals 1.
- **Time**: Obtains current time via NTP to schedule hourly uploads.

## Usage

1. Install libraries for `Adafruit_ST7735`, `Adafruit_GFX`, and `Adafruit_AHTX0` via the Arduino Library Manager.
2. Set your Wi-Fi credentials and the API endpoint URL in `ESP32SmartPlantPot.ino`.
3. Build and flash the sketch to an ESP32 using the Arduino IDE or PlatformIO.

Sensor readings are refreshed every second on the display. Data will be persisted to the remote endpoint once per hour.

## Hardware wiring

As ligacoes de todos os sensores e do display estao documentadas em
[`HardwareConnections.md`](HardwareConnections.md), que inclui um diagrama
em formato Mermaid exibindo os pinos utilizados.
