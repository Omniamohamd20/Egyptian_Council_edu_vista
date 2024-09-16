import 'package:edu_vista_app/pages/cart_page.dart';
import 'package:edu_vista_app/pages/login_page.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'ProfilePage';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String downloadUrl = '';
  String userName = '${FirebaseAuth.instance.currentUser?.displayName}';
  String userEmail = "${FirebaseAuth.instance.currentUser?.email}";

  @override

  void initState() {
    super.initState();
  }

  void editProfile() {
    String tempUserName =
        userName; // Create a temporary variable to hold the new value
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit user name"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) => tempUserName = value,
                controller: TextEditingController(text: userName),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(tempUserName);

                // No need to call FirebaseAuth.instance.currentUser?.reload();
                setState(() {
                  userName = tempUserName; // Update the userName state
                });

                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // User cancels
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // User confirms
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    // If user confirms logout
    if (shouldLogout == true) {
      try {
        await FirebaseAuth.instance.signOut();
        print("User logged out successfully.");

        // Navigate back to the LoginScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print("Error logging out: $e");
      }
    }
  }

  Future<void> uploadImage() async {
    var imageResult = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (imageResult != null) {
      var storageRef = FirebaseStorage.instance
          .ref('images/${imageResult.files.first.name}');
      var uploadResult = await storageRef.putData(
        imageResult.files.first.bytes!,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      if (uploadResult.state == TaskState.success) {
        String url = await uploadResult.ref.getDownloadURL();
        setState(() {
          downloadUrl = url; // Update the state here
        });
        print('Image uploaded successfully: $downloadUrl');
      } else {
        print('Upload failed: ${uploadResult.state}'); // Debugging
      }
    } else {
      print('No file selected'); // Debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Profile")), actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, CartPage.id);
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: uploadImage, // Call the upload function when tapped
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: ColorUtility.main,
                  backgroundImage: downloadUrl.isNotEmpty
                      ? NetworkImage(downloadUrl.trim()) // Trim any whitespace
                      : null,
                  child: downloadUrl.isEmpty
                      ? const Icon(Icons.person,
                          size: 50, color: Colors.white) // Placeholder icon
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 100),
              Column(
                children: [
                  ListTile(
                    tileColor: const Color.fromARGB(255, 206, 203, 203),
                    title: const Text("Edit"),
                    trailing: const SizedBox(
                      width: 30,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_forward_ios,
                              size: 15, color: Colors.black),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      editProfile();
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    tileColor: const Color.fromARGB(255, 206, 203, 203),
                    title: const Text("Setting"),
                    trailing: const SizedBox(
                      width: 30,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_forward_ios,
                              size: 15, color: Colors.black),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    tileColor: const Color.fromARGB(255, 206, 203, 203),
                    title: const Text("About Us"),
                    trailing: const SizedBox(
                      width: 30,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_forward_ios,
                              size: 15, color: Colors.black),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
