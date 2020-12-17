import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token => _prefs.getString('token') ?? '';

  set token( String value ) {
    _prefs.setString('token', value);
  }

  // GET y SET del uid

  get uid => _prefs.getString('uid') ?? ''; 

  set uid( String value ){
    _prefs.setString('uid', value);
  }

  // GET y SET del uid

  get uidGroup => _prefs.getString('uidGroup') ?? ''; 

  set uidGroup( String value ){
    _prefs.setString('uidGroup', value);
  }

  get mode => _prefs.getString('mode') ?? '';

  set mode(String value){
    _prefs.setString('mode', value);
  }

  get lat => _prefs.getString('lat') ?? '';

  set lat(String value){
    _prefs.setString('lat', value);
  }

  get lng => _prefs.getString('lng') ?? '';

  set lng(String value){
    _prefs.setString('lng', value);
  }

}
