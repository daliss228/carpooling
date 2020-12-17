import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';

class MapProvider with ChangeNotifier {
  
  String _hour;
  // int _numUsers;
  String _description;
  Map<String, String> _idUsers;
  
  int _seat = 0;
  bool _auxiliary = false;
  List<bool> _days = List<bool>.generate(7, (i) => false);
  
  LocalityModel _geolocation;
  Set<Marker> _markers = Set<Marker>();
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(-0.179292, -78.486155), zoom: 12);

  Map<String, String> get idUsers => this._idUsers;

  set idUsers(Map<String, String> idUsers) {
    this._idUsers = idUsers;
    notifyListeners();
  }

  // int get numUsers => this._numUsers;

  // set numUsers(int numUsers) {
  //   this._numUsers = numUsers;
  //   notifyListeners();
  // }

  int get seat => this._seat;

  set seat(int seat) {
    this._seat = seat;
    notifyListeners();
  }

  bool get auxiliary => this._auxiliary;

  set auxiliary(bool backArrow) {
    this._auxiliary = backArrow;
    notifyListeners();
  }

  String get hour => this._hour;

  set hour(String hour) {
    this._hour = hour;
    notifyListeners();
  }

  List<bool> get days => this._days;

  set days(List<bool> days){
    this._days = days;
    notifyListeners();
  }

  set schedule(Schedule schedule){
    this.days.clear();
    this._days.add(schedule.monday);
    this._days.add(schedule.tuesday);
    this._days.add(schedule.wednesday);
    this._days.add(schedule.thursday);
    this._days.add(schedule.friday);
    this._days.add(schedule.saturday);
    this._days.add(schedule.sunday);
    notifyListeners();
  }

  String get description => this._description;

  set description(String description) {
    this._description = description;
  }

  LocalityModel get geolocation => this._geolocation;

  set geolocation(LocalityModel localityModel) {
    this._geolocation = localityModel;
    notifyListeners();
  }

  CameraPosition get kGooglePlex => this._kGooglePlex;

  set kGooglePlex(CameraPosition cameraPosition) {
    this._kGooglePlex = cameraPosition;
    notifyListeners();
  }

  Set<Marker> get markers => this._markers;

  set setMarkers(LocalityModel locality) {
    this._markers.clear();
    this._markers.add(Marker(markerId: MarkerId("miMarker"), position: LatLng(locality.lat, locality.lng)));
    notifyListeners();
  }

  void clearValues() {
    this._seat = 0;
    this._hour = null;
    // this._numUsers = null;
    this._idUsers = null;
    this._auxiliary = false;
    this._description = null;
    this._geolocation = null;
    this._markers = Set<Marker>();
    this._kGooglePlex = CameraPosition(target: LatLng(-0.179292, -78.486155), zoom: 12);
    this._days = List<bool>.generate(7, (index) => false);
    notifyListeners();
  }

}