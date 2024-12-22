import 'dart:convert';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:http/http.dart' as http;
import 'package:freelancing/navigationbar/navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  final inputsignup_form = GlobalKey<FormState>();

  // Separate controllers for each field
  final namecontroller = TextEditingController();
  final phnnumcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final userRolecontroller = TextEditingController();

  late FlutterSecureStorage secureStorage;

  @override
  void initState() {
    super.initState();
    secureStorage = FlutterSecureStorage();
  }

  String selected_countrycode = '+977';

  Future<void> sign() async {
    if (inputsignup_form.currentState!.validate()) {
      final name = namecontroller.text;
      final phnnum = '$selected_countrycode${phnnumcontroller.text}';
      final email = emailcontroller.text;
      final password = passwordcontroller.text;

      var reqBody = {
        "Full_Name": name,
        "PhnNumber": phnnum,
        "Email": email,
        "Password": password
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['message']);

      if (jsonResponse['status']) {
        String token = jsonResponse['token'];

        await secureStorage.write(key: 'token', value: token);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationPage()),
            (route) => false);
      } else {
        print("Something wnet wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // Create a linear gradient with purple and white colors
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: inputsignup_form,
                child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        // Name TextForm Field
                        TextFormField(
                          controller: namecontroller,
                          decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                  color: const Color.fromARGB(255, 1, 1, 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Full Name';
                            }
                            if (value.length < 5) {
                              return 'Please enter a valid Full Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // Email TextFormField
                        TextFormField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter valid Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // Phone Number Field
                        Row(
                          children: [
                            CountryCodePicker(
                              onChanged: (code) {
                                setState(() {
                                  selected_countrycode = code.dialCode!;
                                });
                              },
                              initialSelection: 'NP', // Fixed to 'NP' for Nepal
                              favorite: ['+977', 'US', 'IN'],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller:
                                    phnnumcontroller, // Use the correct controller
                                decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Phone Number';
                                  }
                                  if (value.length < 5) {
                                    return 'Please enter a valid Phone Number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // Password TextFormField
                        TextFormField(
                          controller: passwordcontroller,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true, // To hide the password
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            if (value.length < 6) {
                              return 'Please enter at least 6 characters for the password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              sign();
                            },
                            child: Text('SignUp'))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
