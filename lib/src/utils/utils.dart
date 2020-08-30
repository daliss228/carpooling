import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

bool isNumeric(String s){
  if (s.isEmpty) return false; 
  final n = num.tryParse(s); 
  return (n == null) ? false: true;
}

bool atLeast1True(List<bool> days) {
  for (var day in days) {
    if (day == true) return true;
  }
  return false;
}

List<String> numAvalibleSeats(List<RouteModel> routes) {
  List<String> avalibleSeats = [];
  for (RouteModel route in routes) {
    final result = route.driver.car.seat - ((route.users == null) ? 0 : route.users.length);
    avalibleSeats.add(result.toString());
  }
  return avalibleSeats;
}

String stringSchedule(Schedule schedule) {
    String stringDays = "";
    if(schedule.monday == true) {
      stringDays = "Lun - ";
    }
    if (schedule.tuesday == true) {
      stringDays += "Mar - ";
    }
    if (schedule.wednesday == true) {
      stringDays += "Mie - ";
    }
    if (schedule.thursday == true) {
      stringDays += "Jue - ";
    }
    if (schedule.friday == true) {
      stringDays += "Vie - ";
    }
    if (schedule.saturday == true) {
      stringDays += "Sab - ";
    }
    if (schedule.sunday == true) {
      stringDays += "Dom";
    } 
    if (stringDays.endsWith(" - ")) {
      stringDays = stringDays.replaceRange(stringDays.length - 3, stringDays.length, "");
    }
  return stringDays;
}

String nameFromUrlPhoto(String url) => url.replaceAll(RegExp(r'https://firebasestorage.googleapis.com/v0/b/dev-carpooling.appspot.com/o/'), '').replaceAll('%20', ' ').replaceAll('%3A', ':').split('?')[0];

bool verifyUserRegister(List<UserModel> users) {
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  final String myUser = _prefs.uid;
  bool flag = false;
  if (users != null) {
    for (UserModel user in users) {
      if (myUser == user.uid) {
        flag = true;
        break;
      }
    }
  }
  return flag;
}
  