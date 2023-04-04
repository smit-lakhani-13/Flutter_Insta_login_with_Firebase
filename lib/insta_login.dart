// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_login/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return InstaLogin();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class InstaLogin extends StatefulWidget {
  const InstaLogin({super.key});

  @override
  State<InstaLogin> createState() => _InstaLoginState();
}

class _InstaLoginState extends State<InstaLogin> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _topWidget(),
            Flexible(child: Container(), flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _centerWidget(),
            ),
            Flexible(child: Container(), flex: 2),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: _bottomWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topWidget() {
    return DropdownButton(
      value: "English",
      items: const [
        DropdownMenuItem(
          child: Text("English"),
          value: "English",
        )
      ],
      onChanged: (v) {},
    );
  }

  Widget _centerWidget() {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Column(
      children: [
        Image.asset(
          "assets/images/insta_icon.png",
          height: 64,
        ),
        SizedBox(height: 24),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Phone number, email or username",
            border: OutlineInputBorder(
              borderSide: Divider.createBorderSide(context),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: Divider.createBorderSide(context),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: Divider.createBorderSide(context),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(8),
          ),
        ),
        SizedBox(height: 24),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderSide: Divider.createBorderSide(context),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: Divider.createBorderSide(context),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: Divider.createBorderSide(context),
            ),
            filled: true,
            suffixIcon: const Icon(Icons.visibility_off_rounded),
            contentPadding: const EdgeInsets.all(8),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              User? user = await loginUsingEmailPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context);
              print(user);
              if (user != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
              }
            },
            child: Text("Log in"),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Forgot your login details? "),
            Text(
              "Get help logging in.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: const [
              Flexible(child: Divider(thickness: 2)),
              Text(" OR "),
              Flexible(child: Divider(thickness: 2)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/fb_icon.png", height: 32),
            const Text(" Log in with Facebook"),
          ],
        ),
      ],
    );
  }

  Widget _bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Don't have an account? "),
        Text(
          "Sign up.",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
