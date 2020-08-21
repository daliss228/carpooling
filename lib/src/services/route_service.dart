import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class RouteService {

  final dbRef = FirebaseDatabase.instance.reference();

  Future<Map> createRoute(Map<String, dynamic> _route) async {
    try {
      dbRef.child("routes").push().set(_route);
      return {"ok": true};
    } on PlatformException catch (e) {
      return {"ok": false, "message": e.code.toString()};
    }
  }
}
