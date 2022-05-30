import 'package:flutter/material.dart';
import 'package:gotour_mobile/widgets/login_form.dart';
import 'package:gotour_mobile/widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  String _type = 'login';

  void _toggleType(String type) {
    setState(() {
      _type = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 50),
            width: 200,
            child: Image.asset('assets/images/logo.png'),
          ),
          Container(
            alignment: Alignment.topCenter,
            // height: 512,
            margin: const EdgeInsets.only(top: 150),
            padding: const EdgeInsets.only(top: 30),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Text(
              _type == 'login' ? 'Login to your account' : 'Create an account',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(top: 225),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 4,
                  ),
                ]),
            child: _type == 'login'
                ? LoginForm(toggleType: _toggleType)
                : RegisterForm(toggleType: _toggleType),
          ),
        ],
      ),
    );
  }
}
