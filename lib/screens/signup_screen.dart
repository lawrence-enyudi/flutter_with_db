import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupScreen({super.key});

  void signup(BuildContext context) async {
    final firstname = firstnameController.text;
    final lastname = lastnameController.text;
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    final response = await ApiService.post("signup.php", {
      "firstname": firstname,
      "lastname": lastname,
      "username": username,
      "email": email,
      "password": password,
    });

    if (response['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful!")),
      );
      Navigator.pop(context); // Go back to login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Signup Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      backgroundColor: Color(0xFF202D6D), // Light blue background color
      body: Center(
        child: SingleChildScrollView(
          // Allow scroll if the content is too large
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 500), // Set maximum width of the card
            child: Card(
              color: Color(0xffffdb518), // Gold color for the card
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Signup',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: firstnameController,
                      decoration: InputDecoration(labelText: "First Name"),
                    ),
                    TextField(
                      controller: lastnameController,
                      decoration: InputDecoration(labelText: "Last Name"),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "example@gmail.com",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => signup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // White button color
                        foregroundColor:
                            Colors.black, // Text color inside the button
                      ),
                      child: Text("Signup"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
