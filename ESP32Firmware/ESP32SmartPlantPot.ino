#include <WiFi.h>
#include <AWS_IOT.h>
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

// AWS IoT configuration
const char* awsEndpoint = "your-endpoint-ats.iot.your-region.amazonaws.com";
const char* awsClientId = "SmartPlantPot";
const char* awsTopic = "smartpot/sensors";

// Device certificate and key used for AWS IoT authentication
static const char awsCert[] PROGMEM = R"CERT(
-----BEGIN CERTIFICATE-----
YOUR_CERTIFICATE_HERE
-----END CERTIFICATE-----
)CERT";

static const char awsPrivateKey[] PROGMEM = R"KEY(
-----BEGIN RSA PRIVATE KEY-----
YOUR_PRIVATE_KEY_HERE
-----END RSA PRIVATE KEY-----
)KEY";

Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS, TFT_DC, TFT_RST);
Adafruit_AHTX0 aht;
WiFiUDP ntpUDP;
AWS_IOT awsIot;
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

  // Connect to AWS IoT using certificate authentication
  if (awsIot.begin(awsEndpoint, awsClientId, awsCert, awsPrivateKey) == 0) {
    Serial.println("Connected to AWS IoT");
  } else {
    Serial.println("AWS IoT connection failed");
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
    publishToAWSIoT(temperature, humidityPercent, soilRaw, lightRaw);
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

void publishToAWSIoT(float tempC, float humidity, int soil, int light) {
  if (WiFi.status() != WL_CONNECTED) {
    return;
  }

  String payload = "{";
  payload += "\"temperature\":" + String(tempC, 2) + ",";
  payload += "\"humidity\":" + String(humidity, 2) + ",";
  payload += "\"soil\":" + String(soil) + ",";
  payload += "\"light\":" + String(light);
  payload += "}";

  awsIot.publish(awsTopic, payload);
}
