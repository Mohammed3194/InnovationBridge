import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:innovation_bridge/entities/MapDetail.dart';


class MapScreen extends StatefulWidget {

  MapDetail detail;
  String title;
  String subTitle;
  String location;
  MapScreen({@required this.detail, @required this.title, @required this.subTitle, @required this.location});

  @override
  _MapScreenState createState() => _MapScreenState(detail, title, subTitle, location);
}

class _MapScreenState extends State<MapScreen> {

  MapDetail detail;
  String title;
  String subTitle;
  String location;
  _MapScreenState(this.detail, this.title, this.subTitle, this.location);

  /*Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  LatLng _center = const LatLng(45.521563, -122.677433);

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _center = position.target;
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*_markers.add(
      Marker(
        markerId: MarkerId(_center.toString()),
        position: LatLng(45.521563, -122.677433),
        infoWindow: InfoWindow(
          title: 'This is a Title',
          snippet: 'This is a snippet',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {

    print('@@ map image url == '+detail.data.mapUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(title,
                          softWrap: true,
                          style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      )),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(subTitle, style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                          )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(location, style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent,
                              ))
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              child: Image.network(detail.data.mapUrl,
                loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ?
                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
              // Image.network(detail.data.mapUrl),
              /*child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(45.521563, -122.677433),
                  zoom: 11.0,
                ),
                // mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),*/
            ),
          ),
        ],
      )
    );
  }
}
