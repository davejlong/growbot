#include <SPI.h>
#include <Ethernet.h>
#include <SD.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress server(192,168,1,98);
const int serverPort = 80;
IPAddress ip(192,168,1,15);
EthernetClient client;

// On the Ethernet Shield, CS is pin 4. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 4;

// The following drives the sensor array
// sensorPins is a list of pins that are running sensors
// sensorLabels is the labels to use in the POST request
// sensorCount is the number of sensors on board
const int sensorPins[] = { 0, 1 };
const String sensorLabels[] = { "light", "moisture" };
const int sensorCount = 2;

void setup () {
  if (Ethernet.begin(mac) == 0) {
    Ethernet.begin(mac, ip);
  }

  pinMode(10, OUTPUT);
  SD.begin(chipSelect);

  delay(1000);
}

void loop () {
  /*
  Example HTTP Post:

  POST /track HTTP/1.1
  Host: 192.168.1.98:9292
  User-Agent: Arduino/1.0
  Connection: close
  Content-Length: 9

  light=392
  */

  String postBody = readSensors();

  File dataFile = SD.open("data.log", FILE_WRITE);
  if (dataFile) {
    dataFile.println(postBody);
    dataFile.close();
  }

  File accessFile = SD.open("access.log", FILE_WRITE);
  if (accessFile) {
    accessFile.println("Sending request");
  }

  if (client.connect(server, serverPort)) {
    sendRequest(postBody);
    accessFile.println("Successfully sent request");
  } else {
    accessFile.println("Couldn't connect to server");
  }

  if (accessFile) { accessFile.close(); }

  delay(30000);
}

void sendRequest (String postBody) {
  client.println("POST /track HTTP/1.1");
  client.print("Host: ");
  client.print(server);
  client.print(":");
  client.println(serverPort);
  client.println("User-Agent: Arduino/1.0");
  client.println("Connection: close");
  client.print("Content-Length: ");
  client.println(postBody.length());
  client.println();
  client.println(postBody);
  client.stop();
}

String readSensors () {
  String sensorString = "";
  for (int i = 0; i < sensorCount; i++) {
    if (i > 0) { sensorString += "&"; }
    sensorString += sensorLabels[i];
    sensorString += "=";
    sensorString += analogRead(sensorPins[i]);
  }
  return sensorString;
}
