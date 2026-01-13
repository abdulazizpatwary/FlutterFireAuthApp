import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Authent"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _googleSignin(),
                child: Text(
                  "google-signin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => _signWithemail(),
                child: Text(
                  "email-signin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () {
                  _createUser();
                },
                child: Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () => logOut(),
                child: Text("LogOut", style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.indigoAccent),
              onPressed: () => _emailSignout(),
              child: Text(
                "EmailSignOut",
                style: TextStyle(color: Colors.white),
              ),
            ),

            Image.network(
              imageUrl == null || imageUrl!.isEmpty
                  ? "https://picsum.photos/250?image=9"
                  : imageUrl!,
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> _googleSignin() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn
        .authenticate();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final user = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(
      user,
    );
    print("User is: ${userCredential.user!.displayName}");
    setState(() {
      imageUrl = userCredential.user!.photoURL;
    });
    return userCredential.user;
  }

  Future<User?> _createUser() async {
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: "gracie@gmail.com",
      password: "gracie12345",
    );
    final User? user = userCred.user;
    print("User Created:${user?.email}");
    return user;
  }

  void logOut() {
    setState(() {
      _googleSignIn.signOut();
      imageUrl = null;
    });
  }

  _signWithemail() async {
    UserCredential credUser = await _auth.signInWithEmailAndPassword(
      email: "gracie@gmail.com",
      password: "gracie12345",
    );
    final User? user = credUser.user;
    print("User Signed in: ${user!.email}");
  }

  void _emailSignout() {
    _auth.signOut();
  }
}
