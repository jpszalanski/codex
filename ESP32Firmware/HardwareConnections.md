# Hardware Connections

Este documento descreve como conectar os sensores e o display ao ESP32 conforme utilizado no firmware `ESP32SmartPlantPot.ino`.

## Sensor de umidade de solo capacitivo
- **VCC** -> 3.3&nbsp;V
- **GND** -> GND
- **AOUT** -> GPIO 34 (leitura analógica)

## Sensor de luminosidade (LDR + resistor)
- LDR ligado a 3.3&nbsp;V
- Resistor (~10kΩ) para GND
- Ponto comum (entre LDR e resistor) -> GPIO 35 (leitura analógica)

## Sensor AHT10 (temperatura e umidade)
- **VCC** -> 3.3&nbsp;V
- **GND** -> GND
- **SDA** -> GPIO 21 (I2C)
- **SCL** -> GPIO 22 (I2C)

## Display ST7735 1.8"
- **VCC** -> 3.3&nbsp;V
- **GND** -> GND
- **CS** -> GPIO 5
- **DC** -> GPIO 16
- **RST** -> GPIO 17
- **MOSI** -> GPIO 23 (SPI)
- **SCLK** -> GPIO 18 (SPI)
- **MISO** -> GPIO 19 (opcional)

> **Nota:** os pinos MOSI, SCLK e, quando necessário, MISO utilizam o barramento SPI padrão do ESP32.

## Diagrama de ligações

```mermaid
graph LR
  subgraph Power
    VCC((3.3V))
    GND((GND))
  end

  Soil["Sensor de umidade"]
  LDR["LDR + resistor"]
  AHT10["AHT10"]
  Display["Display ST7735"]
  ESP32((ESP32))

  Soil -- AOUT --> ESP32:::pin34
  LDR -- analog --> ESP32:::pin35
  AHT10 -- SDA --> ESP32:::pin21
  AHT10 -- SCL --> ESP32:::pin22
  Display -- CS --> ESP32:::pin5
  Display -- DC --> ESP32:::pin16
  Display -- RST --> ESP32:::pin17
  Display -- MOSI --> ESP32:::pin23
  Display -- SCLK --> ESP32:::pin18
  Display -- MISO --> ESP32:::pin19

  Soil --- VCC
  Soil --- GND
  LDR --- VCC
  LDR --- GND
  AHT10 --- VCC
  AHT10 --- GND
  Display --- VCC
  Display --- GND

  classDef pins fill:#ffd,stroke:#333,stroke-width:1px;
  class ESP32 pins;
```

