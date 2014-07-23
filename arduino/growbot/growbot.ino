#include <SPI.h>
#include <Ethernet.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress server(192,168,1,98);
const int serverPort = 80;
IPAddress ip(192,168,1,15);
EthernetClient client;

const int lightPin = 0;

void setup () {
  if (Ethernet.begin(mac) == 0) {
    Ethernet.begin(mac, ip);
  }
  
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
  if (client.connect(server, serverPort)) {
    int lightReading = getLight();
    String postBody = "light=";
    postBody += lightReading;
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
  delay(30000);
}

int getLight () {
  return analogRead(lightPin);
}
