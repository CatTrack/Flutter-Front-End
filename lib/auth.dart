import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWIthEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print(user);
    return user.uid;
  }

  Future<String> createUserWIthEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    print(user);
    return user.uid;
  }

  Future<String> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }


}