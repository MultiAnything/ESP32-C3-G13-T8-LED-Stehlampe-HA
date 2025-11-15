#include <Arduino.h>

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("ESP32-C3 G13_LED_UltraSlim Stehlampe-HA");
  Serial.println("Project initialized");
}

void loop() {
  // Main loop
  delay(1000);
}

