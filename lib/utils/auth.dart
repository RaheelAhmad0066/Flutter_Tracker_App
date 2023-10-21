

/*import '../data/database_helper.dart';*/

enum AuthState { LOGGEDIN, LOGGEDOUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState authState);
}

//a naive implementation of observer and subscriber pattern. will do for now
class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  List<AuthStateListener> _subscriber=[];

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscriber= <AuthStateListener>[];
   // initState();
  }

 /* void initState() async {
    var db = new DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn)
      notify(AuthState.LOGGEDIN);
    else
      notify(AuthState.LOGGEDOUT);
  }*/

  void subscribe(AuthStateListener listener) {
    _subscriber.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for (var l in _subscriber) {
      if (l == _subscriber) {
        _subscriber.remove(l);
      }
    }
  }

  void notify(AuthState state) {
    _subscriber.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}

//this class defines a broadcaster/observable kind of object that can notify its subscribers
//of any change in AuthState i.e. logged in or not. Use something like Redux for this kind of
//global states in your app.
