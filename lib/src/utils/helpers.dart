import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';


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
  List<String> avalibleSeats = new List<String>();
  for (RouteModel route in routes) {
    final result = route.seat - ((route.users == null) ? 0 : route.users.length);
    avalibleSeats.add(result.toString());
  }
  return avalibleSeats;
}

String readableDate(String time) => toBeginningOfSentenceCase(DateFormat('yMMMMd', 'es').format(DateTime.parse(time)));

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

bool verifyUserRegister(List<UserModel> users) {
  final UserPreferences _prefs = UserPreferences();
  final String myUser = _prefs.uid;
  if (users != null) {
    for (UserModel user in users) {
      if (myUser == user.id) {
        return true;
      }
    }
  }
  return false;
}

double getKilometers(double lat1, double lon1, double lat2, double lon2){
  double r = 6378.137;
  double dLat = rad( lat2 - lat1 );
  double dLon = rad( lon2 - lon1 );  
  double a = sin(dLat/2) * sin(dLat/2) + cos(rad(lat1)) * cos(rad(lat2)) * sin(dLon/2) * sin(dLon/2);
  double c = 2 * atan2( sqrt(a) , sqrt(1 - a));
  double d = r * c;
  int fac = pow(10, 3);
  return (d * fac).round()/fac; 
}

double rad( double x ){
  return x*pi/180;
}

bool validatorChecks(List<bool> checks) {
  for (bool check in checks) {
    if (check) {
      return true;
    }
  }
  return false;
}

double driverRating(Map<String, double> ratings) {
  if (ratings != null) {    
    return ratings.values.map((rate) => rate).reduce((a, b) => a + b) / ratings.length;
  } else {
    return 0;
  }
}

double checkIfUserRated(Map<String, double> ratings, String myID) {
  if (ratings != null) {
    for (var rate in ratings.entries) {
      if (rate.key == myID) {
        return rate.value;
      }
    }
  }
  return 0;
}

String firebaseErrorMessages(String err) {
  switch (err) {
    case "wrong-password":
      return "Contraseña no válida."; 
    case "user-not-found":
    case "invalid_email":
    case "email-already-in-use":
    case "account-exists-with-different-credential":
      return "Correo electrónico no válido."; 
      break;
    case "too-many-requests":
      return "Demasiados intentos fallidos. \nPor favor, inténtelo de nuevo más tarde."; 
      break;
    case "user-disabled":
      return "Usuario deshabilitado. \nCuenta deshabilitada por el administrador."; 
      break;
    case "network-request-failed":
      return "Error de red. \nConexión interrumpida o host inaccesible."; 
      break;
    default:
      return "Acción fallida. \nPor favor, intente otra vez."; 
      break;
  }
}

class Reports {
  static List<String> list = [
    "Actitud grosera, vulgar o insultante",
    "Discurso que denota acoso o odio",
    "Actitud amenazante, violenta o suicida",
    "No se ha presentado",
    "Ha dejado de responder",
    "Otro hecho inadecuado"
  ];
}