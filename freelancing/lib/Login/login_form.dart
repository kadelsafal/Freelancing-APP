import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigationbar/navigation.dart';
import './login_config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final input_form = GlobalKey<FormState>();
  final emailfield = TextEditingController();
  final passwordfield = TextEditingController();

  bool isPasswordvisible = true;
  late FlutterSecureStorage secureStorage;
  String? _errorMessage; // Variable to store error message

  @override
  void initState() {
    super.initState();
    secureStorage = FlutterSecureStorage();
  }

  Future<void> islogin() async {
    if (input_form.currentState!.validate()) {
      final email = emailfield.text;
      final password = passwordfield.text;

      var reqBody = {"Email": email, "Password": password};
      var response = await http.post(Uri.parse(login),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse['status']) {
          String token = jsonResponse['token'];

          await secureStorage.write(key: 'token', value: token);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NavigationPage()),
              (route) => false);
        } else {
          // If login is unsuccessful, set the error message
          setState(() {
            _errorMessage = jsonResponse['message'] ?? 'Unknown error occurred';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Something went wrong, please try again later';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: input_form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email TextFormField
            TextFormField(
              controller: emailfield,
              decoration: InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your Email";
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            // Password TextFormField
            TextFormField(
              controller: passwordfield,
              obscureText: !isPasswordvisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordvisible = !isPasswordvisible;
                        });
                      },
                      icon: Icon(isPasswordvisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                if (value.length < 6) {
                  return 'Password must be of minimum 6 letters';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            // Display the error message here
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: islogin, child: Text('Login'))
          ],
        ),
      ),
    );
  }
}
