import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupScreen({super.key});

  void signup(BuildContext context) async {
    final response = await ApiService.post("signup.php", {
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
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
      body: Container(
        color:
            Color.fromARGB(255, 219, 219, 219), // Light Blue background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () => signup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White button
                ),
                child: Text("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      final response = await ApiService.post("profile.php", {
        "email": widget.email,
      });

      if (response['status'] == "success") {
        setState(() {
          userData = response['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? "Failed to fetch user data")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user data")),
      );
    }
  }

  void updateUserData(Map<String, String> updatedData) async {
    try {
      final response = await ApiService.post("update_profile.php", updatedData);

      if (response['status'] == "success") {
        setState(() {
          userData = response['data'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? "Failed to update profile")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  void showEditDialog() {
    final firstnameController =
        TextEditingController(text: userData['firstname']);
    final lastnameController =
        TextEditingController(text: userData['lastname']);
    final usernameController =
        TextEditingController(text: userData['username']);
    final emailController = TextEditingController(text: userData['email']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  "firstname": firstnameController.text,
                  "lastname": lastnameController.text,
                  "username": usernameController.text,
                  "email": emailController.text,
                };
                updateUserData(updatedData);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        color:
            Color.fromARGB(255, 214, 214, 214), // Light Blue background color
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : SizedBox(
                  width: 350, // Adjusted width for the card
                  height: 500, // Adjusted height for the card
                  child: Card(
                    margin: EdgeInsets.all(16.0),
                    color: Color.fromARGB(
                        255, 255, 255, 255), // White color for card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Profile',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          if (userData.isNotEmpty) ...[
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('First Name'),
                              subtitle: Text(userData['firstname']),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Last Name'),
                              subtitle: Text(userData['lastname']),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text('Username'),
                              subtitle: Text(userData['username']),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text('Email'),
                              subtitle: Text(userData['email']),
                            ),
                          ],
                          Spacer(),
                          ElevatedButton(
                            onPressed: showEditDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              foregroundColor: Colors.white, // Text color
                            ),
                            child: Text("Edit Profile"),
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
