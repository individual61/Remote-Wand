#include <Arduino.h>
#include <ESP8266WiFi.h>

const char *ssid = "";     // type your ssid
const char *password = ""; // type your password

WiFiServer server(80);

void setup() {
  Serial.begin(115200);
  delay(10);

  // prepare GPIO2 (out)
  //  pinMode(2, OUTPUT);
  //  digitalWrite(2, 0);

  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();

  Serial.print("Connected, IP address: ");
  Serial.println(WiFi.localIP());

  server.begin();
  Serial.println("Server started");
}

void loop() {

  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  // Below this line, we have a client connected
  Serial.println("New client connected.");
  while (!client.available()) {
    delay(1);
  }

  // Read only one line of client request
  String req = client.readStringUntil('\r');
  Serial.println(req);
  client.flush();

  int val;
  if (req.indexOf("/gpio/0") != -1)
    val = 0;
  else if (req.indexOf("/gpio/1") != -1)
    val = 1;
  else {
    Serial.println("invalid request");
    client.stop();
    return;
  }

} // loop
