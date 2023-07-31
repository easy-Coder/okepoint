import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import '../app.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions currentPlatform(AppFlavor flavor) {
    FirebaseOptions? options;
    options = devOptions;

    return options;
  }

  static const FirebaseOptions devOptions = FirebaseOptions(
    apiKey: "AIzaSyB8QsvK04r5E7D9bhSeX7q7v_PoOrCiW-U",
    authDomain: "okepoint-dev.firebaseapp.com",
    projectId: "okepoint-dev",
    storageBucket: "okepoint-dev.appspot.com",
    messagingSenderId: "244445171854",
    appId: "1:244445171854:web:8cd344849bdd7d0c0b79df",
    measurementId: "G-MT4F87GFM2",
  );
}
