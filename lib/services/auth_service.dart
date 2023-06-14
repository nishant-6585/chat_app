import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login


  //register
  Future registerUserWithEmailAndPassword(String fullName, String email,
      String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).user!;
      if (user != null) {
        //call our database service to update the user data
        await DatabaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out
  Future signOut() async{
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserName("");
      await HelperFunction.saveUserEmail("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

}