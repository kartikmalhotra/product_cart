import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  /// Instance of [FirebaseService]
  static FirebaseServices? _instance;
  static FirebaseAuth? _firebaseAuth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _firebaseStorage;

  FirebaseServices._internal();

  FirebaseFirestore? get firestoreInstance => _firestore;

  static Future<FirebaseServices> getInstance() async {
    /// Intialize Firebase App Instance
    await Firebase.initializeApp();

    /// FirebaseAuth Instance
    _firebaseAuth = FirebaseAuth.instance;

    /// Cloud Firestore
    _firestore = FirebaseFirestore.instance;

    /// Firebase Storage
    _firebaseStorage = FirebaseStorage.instance;

    if (_instance == null) {
      _instance = FirebaseServices._internal();
    }

    firebaseAuthChanges();
    idTokenChanges();

    return _instance!;
  }

  bool checkUser() {
    if (_firebaseAuth!.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  /// Listen for Firebase Auth Changes
  static void firebaseAuthChanges() {
    _firebaseAuth!.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {}
    });
  }

  /// Listen for id Token Changes
  static void idTokenChanges() {
    _firebaseAuth!.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  /// Listen for user Changes
  static void userChanges() {
    _firebaseAuth!.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  /// Create New User using firebase
  Future<dynamic> createNewUser(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.code;
    } catch (e) {
      print(e);
    }
  }

  /// This Function is used to Sign in with email password
  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      UserCredential _userCredential = await _firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);

      return _userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'Please enter a valid email';
      } else if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return "SignIn unsucessful";
    } catch (e) {
      return "SignIn unsucessful";
    }
  }

  /// This function is to use signIn with Google
  Future<dynamic> signInWithGoogle() async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _firebaseAuth!.signInWithCredential(credential);

        user = userCredential.user;
        // await storeUserCredentials(user);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          return e;
        } else if (e.code == 'invalid-credential') {
          return e;
        }
      } catch (e) {
        return e;
      }
    }

    return user;
  }

  Future<dynamic> addProduct(
      String name, String description, num price, File image) async {
    String? message;

    String imageName = image.path
        .substring(image.path.lastIndexOf("/"), image.path.lastIndexOf("."))
        .replaceAll("/", "");

    TaskSnapshot? task;

    try {
      task = await _firebaseStorage?.ref('product/$imageName').putFile(image);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        message = 'User does not have permission to upload to this reference.';
      }
    }

    await _firestore!.collection("proiduct_data").add({
      "name": name,
      "description": description,
      "price": price,
      "imageURL": await task?.ref.getDownloadURL() ?? "",
      "created_at": new DateTime.now(),
      "updated_at": new DateTime.now()
    }).whenComplete(() => message = "success");
    return message;
  }
  // Future<void> storeUserCredentials(User? user) async {
  //   if (user != null) {
  //     InstaUser.storeUserInfoGoogleSignIn(user);

  //     Application.storageService?.isUserLoggedIn = true;
  //     Application.secureStorageService?.username =
  //         Future.value(InstaUser.userName);
  //     Application.secureStorageService?.email = Future.value(InstaUser.email);
  //   }
  // }

  // Future<void> signOut({required BuildContext context}) async {
  //   try {
  //     await firebaseAuthInstance!.signOut();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error signing out. Try again.'),
  //       ),
  //     );
  //   }
  // }
}
