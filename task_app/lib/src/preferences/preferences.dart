import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class UserPreferences {
  static final UserPreferences _instancia = new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // USERNAME
  String get username {
    return _prefs.getString('username') ?? '';
  }

  set username(String value) {
    _prefs.setString('username', value);
  }

  // ACCESS TOKEN
  String get accessToken {
    return _prefs.getString('accessToken') ?? '';
  }

  set accessToken(String value) {
    _prefs.setString('accessToken', value);
  }

  // REFRESH TOKEN
  String get refreshToken {
    return _prefs.getString('refreshToken') ?? '';
  }

  set refreshToken(String value) {
    _prefs.setString('refreshToken', value);
  }
}
