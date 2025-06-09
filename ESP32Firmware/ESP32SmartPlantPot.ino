#include <WiFi.h>
#include <HTTPClient.h>
#include <Wire.h>
#include <Adafruit_AHTX0.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ST7735.h>
#include <SPI.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

// Pin configuration
#define SOIL_PIN 34
#define LDR_PIN 35
#define TFT_CS 5
#define TFT_DC 16
#define TFT_RST 17

// WiFi credentials
const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

// Endpoint for posting sensor data to DynamoDB
const char* dynamoEndpoint = "https://example.execute-api.region.amazonaws.com/prod/log";

Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS, TFT_DC, TFT_RST);
Adafruit_AHTX0 aht;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 0, 60000); // Update every 60s

uint8_t lastSavedHour = 255; // Track last hour we stored data

void setup() {
  Serial.begin(115200);
  Wire.begin();

  tft.initR(INITR_BLACKTAB);
  tft.fillScreen(ST77XX_BLACK);
  tft.setTextColor(ST77XX_WHITE);
  tft.setTextSize(1);

  if (!aht.begin()) {
    Serial.println("Failed to find AHT10 sensor");
  }

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }

  timeClient.begin();
}

void loop() {
  timeClient.update();

  sensors_event_t humidity, temp;
  aht.getEvent(&humidity, &temp);

  int soilRaw = analogRead(SOIL_PIN);
  int lightRaw = analogRead(LDR_PIN);

  float temperature = temp.temperature;
  float humidityPercent = humidity.relative_humidity;

  displayValues(temperature, humidityPercent, soilRaw, lightRaw);

  if (timeClient.getMinutes() == 1 && timeClient.getHours() != lastSavedHour) {
    lastSavedHour = timeClient.getHours();
    sendToDynamoDB(temperature, humidityPercent, soilRaw, lightRaw);
  }

  delay(1000);
}

void displayValues(float tempC, float humidity, int soil, int light) {
  tft.fillScreen(ST77XX_BLACK);
  tft.setCursor(0, 0);
  tft.print("Temp: ");
  tft.print(tempC);
  tft.println(" C");

  tft.print("Hum:  ");
  tft.print(humidity);
  tft.println(" %");

  tft.print("Soil: ");
  tft.println(soil);

  tft.print("Light: ");
  tft.println(light);
}

void sendToDynamoDB(float tempC, float humidity, int soil, int light) {
  if (WiFi.status() != WL_CONNECTED) {
    return;
  }

  HTTPClient http;
  http.begin(dynamoEndpoint);
  http.addHeader("Content-Type", "application/json");

  String payload = "{";
  payload += "\"temperature\":" + String(tempC, 2) + ",";
  payload += "\"humidity\":" + String(humidity, 2) + ",";
  payload += "\"soil\":" + String(soil) + ",";
  payload += "\"light\":" + String(light);
  payload += "}";

  http.POST(payload);
  http.end();
}
