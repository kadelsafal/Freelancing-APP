import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freelancing/Login/login_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullName;
  String? email;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    String? token =
        await secureStorage.read(key: 'token'); // Get the token securely
    if (token != null) {
      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // Extract user details from the token payload
      setState(() {
        fullName = decodedToken['Full_Name'];
        email = decodedToken['Email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$fullName"),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login_Screen()),
                  (route) => false,
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome, $fullName'),
      ),
    );
  }
}
