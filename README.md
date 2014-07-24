# Growbot

Growbot is your friendly gardening monitor. It's built in 3 parts: Sensor array, Collection API and web client.

## Sensor Array

The sensor array, found in `./arduino/growbot` is an Arduino based program with components for reading data from sensors, connecting to the collection API over a network and logging data to an on board SD card.

## Collection API

Growbot's collection API is a basic REST API build with [Sinatra](http://sinatrarb.com) and [CouchDB](https://couchdb.apache.org/). It's built to be very lightweight and run on a Raspberry Pi board.

### Tracking endpoint `POST /track`

The tracking API endpoint collects data sent from the _Sensor Array_. It accepts standard key/value pairs in the post body (ex. `light=325&moisture=562`) and submits them, with a timestamp, to the database in CouchDB

### Metrics endpoint `GET /`

You can read metrics from the metrics endpoint, which will return an array of metrics collected through the _Tracking Endpoint_.

## Web Client

The web client is a friendly to use display of metrics data collected from the _Sensor Array_. It's built with Angular JS and can be found in `./public`. It's a complete application on it's own and can run seperately from the _Collection API_.