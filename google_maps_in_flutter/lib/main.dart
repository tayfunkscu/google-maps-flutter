// @dart = 2.0
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          backgroundColor: Colors.white,
        ),
        home: Scaffold(
          body: Center(
              child: Column(children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
                    child: Image(
                      image: AssetImage('assets/mainLogo.png'),
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0,50,20.0,10),
                    height: 45,
                    width: 240,
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text('First Query', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.toDouble())),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new firstQueryResponse()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    )),
                Container(
                  height: 45,
                  width: 240,
                    margin: EdgeInsets.fromLTRB(0,0,0,10),
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text('Second Query', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.toDouble())),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new secondQueryInput()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    )),
                Container(
                    height: 45,
                    width: 240,
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text('Third Query', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.toDouble())),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new thirdQueryInput()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    )),
              ])),
        ));
  }
}

// ignore: camel_case_types
class firstQueryResponse extends StatefulWidget {
  @override
  createState() => new firstQueryState();
}

// ignore: camel_case_types
class firstQueryState extends State<firstQueryResponse> {
  var _queryResult = '';

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text('First Query Results'),
      ),
      body: Center(
        child : Column(children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 50) ,
              child: Text("Top 5 days which has the most passenger count", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
            ),
          ),
          Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20) ,
                child: Column(children: <Widget>[
                  Text("Date/Passenger Count", textAlign: TextAlign.left ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.toDouble())),
                ],
                )
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child : Text(_queryResult,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.toDouble())),
            ),
          )
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getFirstQueryResult();
  }

  _getFirstQueryResult() async {
    var url = 'CLOUD FUNCTION - QUERY 1';
    var httpClient = new HttpClient();
    String result="";
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonResponse = await response.transform(utf8.decoder).join();
        var newResponse = jsonResponse.substring(1,jsonResponse.length-1);
        print(newResponse);
        var data = json.decode(newResponse);

        for(var i=0; i<5; i++){
          var pickup = data[i]['dt']['value'].toString();
          var passCount = data[i]['pc'].toString();
          var line = pickup + "        " + passCount + "\n\n";
          result = result + line;
        }

      } else {
        result =
        'Error getting a random quote:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }

    setState(() {
      _queryResult = result;
    });
  }
}

class secondQueryInput extends StatefulWidget {
  @override
  createState() => new _sqIState();
}

var timestamp1,timestamp2;
class _sqIState extends State<secondQueryInput>{
  DateTime _dateTime1,_dateTime2;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text(''),
      ),
      body: Center(
        child : Column(
            children: <Widget>[
              Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 40) ,
                    child: Column(
                      children: <Widget>[
                        Text("5 trips that have least distance between selected dates", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                      ],
                    )
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
                      onPressed: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime(2020,12),
                            firstDate: DateTime(2020,12),
                            lastDate: DateTime(2020,12,31)
                        ).then((date){
                          setState(() {
                            _dateTime1 = date;
                            timestamp1 = (date.microsecondsSinceEpoch/1000000).round();
                            print(timestamp1);
                          });
                        });
                      },
                      child: Text(_dateTime1 == null ? 'Choose Start Date' : _dateTime1.toString().substring(0,10),style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber) ),
                      onPressed: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime(2020,12),
                            firstDate: DateTime(2020,12),
                            lastDate: DateTime(2020,12,31)
                        ).then((date){
                          setState(() {
                            _dateTime2 = date;
                            timestamp2 = (date.microsecondsSinceEpoch/1000000).round();
                            print(timestamp2);
                          });
                        });
                      },
                      child: Text(_dateTime2 == null ? ' Choose End Date ' : _dateTime2.toString().substring(0,10), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 40) ,
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => new secondQueryResult()),
                          );
                        },
                        child: Text('See result!', textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class secondQueryResult extends StatefulWidget {
  @override
  createState() => new _sQRState();
}

class _sQRState extends State<secondQueryResult> {
  var _queryResult = '';

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text('Second Query Results'),
      ),
      body: Center(
        child : Column(children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 50) ,
              child: Text("5 trips that have least distance between selected dates", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
            ),
          ),
          Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20) ,
                child: Column(children: <Widget>[
                  Text("    Date/Time            Distance", textAlign: TextAlign.left ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22.toDouble())),
                ],
                )
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child : Text(_queryResult,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.toDouble())),
            ),
          )
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getSecondQueryResult();
  }

  _getSecondQueryResult() async {
    var startDate = timestamp1.toString();
    var endDate = timestamp2.toString();
    var url = 'CLOUD FUNCTION - QUERY 2';
    var httpClient = new HttpClient();
    String result="";
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonResponse = await response.transform(utf8.decoder).join();
        var newResponse = jsonResponse.substring(1,jsonResponse.length-1);
        print(newResponse);
        var data = json.decode(newResponse);

        for(var i=0; i<5; i++){
          var pickup = (DateFormat('dd.MM.yyyy hh:mm aaa').format(DateTime.fromMillisecondsSinceEpoch(data[i]['tpep_pickup_datetime']*1000))).toString();
          var distance = data[i]['trip_distance'].toString();
          var line = pickup + "     -    " + distance + " mi\n\n";
          result = result + line;
        }

      } else {
        result =
        'Error getting a random quote:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }

    setState(() {
      _queryResult = result;
    });
  }
}

class thirdQueryInput extends StatefulWidget {
  @override
  createState() => new _tqIState();
}

class _tqIState extends State<thirdQueryInput>{
  DateTime _dateTime1;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Text(''),
      ),
      body: Center(
        child : Column(
            children: <Widget>[
              Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 40) ,
                    child: Column(
                      children: <Widget>[
                        Text("Draw the route on the map of the longest trip on a given day", textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                      ],
                    )
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
                      onPressed: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime(2020,12),
                            firstDate: DateTime(2020,12),
                            lastDate: DateTime(2020,12,31)
                        ).then((date){
                          setState(() {
                            _dateTime1 = date;
                            timestamp1 = (date.microsecondsSinceEpoch/1000000).round();
                            print(timestamp1);
                          });
                        });
                      },
                      child: Text(_dateTime1 == null ? 'Choose Date' : _dateTime1.toString().substring(0,10), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.toDouble())),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 40) ,
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => new thirdQueryResult()),
                          );
                        },
                        child: Text('See result!', textAlign: TextAlign.center ,style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.toDouble())),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class thirdQueryResult extends StatefulWidget {
  @override
  createState() => new _tQRState();
}

// ignore: camel_case_types
class _tQRState extends State<thirdQueryResult> {
  List<LatLng> _queryResult;

  @override
  void initState() {
    super.initState();
    _getThirdQueryResult();
  }

  final Map<String, Marker> _markers = {};
  final Set<Polyline> polyline = {};

  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "API KEY");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Third Query Result'),
          backgroundColor: Colors.amber,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(40.62861224,-73.98956041),
                zoom: 10,
              ),
              markers: _markers.values.toSet(),
              polylines: polyline,
            ),
            AnimatedPositioned(
                bottom: 0, right: 0, left: 0,
                duration: Duration(milliseconds: 200),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        margin: EdgeInsets.all(20),
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 20,
                                  offset: Offset.zero,
                                  color: Colors.grey.withOpacity(0.5)
                              )]
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Image.asset(
                                      'assets/redMarker.png',
                                      width: 50, height: 50)
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                          Text("Origin"),
                                          Text("Latitude: ${_queryResult == null ? "" : _queryResult[0].latitude.toString()}",
                                            style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey
                                            )
                                          ),
                                          Text("Longitude: ${_queryResult == null ? "" : _queryResult[0].longitude.toString()}",
                                            style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey
                                            )
                                          ),
                                        ],
                                    ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Destination"),
                                      Text("Latitude: ${_queryResult == null ? "" : _queryResult[1].latitude.toString()}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey
                                          )
                                      ),
                                      Text("Longitude: ${_queryResult == null ? "" : _queryResult[1].longitude.toString()}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Image.asset(
                                      'assets/blueMarker.png',
                                      width: 50, height: 50)
                              ),  // end of Padding
                            ]
                        )
                    )
                )
            )
          ],
        )
      ),
    );
  }


  _getThirdQueryResult() async {
    timestamp2 = timestamp1+86400;
    var startDate = timestamp1.toString();
    var endDate = timestamp2.toString();
    var url = 'CLOUD FUNCTION - QUERY 3';
    var httpClient = new HttpClient();

    List<LatLng> markerList = [];
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var jsonResponse = await response.transform(utf8.decoder).join();
      var newResponse = jsonResponse.substring(1,jsonResponse.length-1);
      var data = json.decode(newResponse);
      markerList.add(new LatLng(data[0]['latitude'], data[0]['longitude']));
      markerList.add(new LatLng(data[1]['latitude'], data[1]['longitude']));

      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: markerList[0],
          destination: markerList[1],
          mode: RouteMode.driving);
      setState(() {
        _queryResult = markerList;
        var i=0;
        for (final location in _queryResult) {
          var index = i.toString();
          final marker = Marker(
            markerId: MarkerId(index),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(i == 0 ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue),
          );
          _markers[index] = marker;
          i = i+1;
        }

        polyline.add(Polyline(
            polylineId: PolylineId('route1'),
            visible: true,
            points: routeCoords,
            width: 4,
            color: Colors.blue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap));
      });
    }
  }
}