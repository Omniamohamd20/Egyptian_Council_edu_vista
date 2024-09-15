import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String downloadUrl =
      'https://firebasestorage.googleapis.com/v0/b/edu-vista-71bae.appspot.com/o/images%2Fads2.jpg?alt=media&token=50790d57-5f68-4757-83ef-08ab92202bf6';
  String userName = "John Doe";
  String userEmail = "john.doe@example.com";
  String userBio = "Web Developer and Designer.";

  void editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        String? newName = userName;
        String? newEmail = userEmail;
        String? newBio = userBio;

        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) => newName = value,
                controller: TextEditingController(text: userName),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) => newEmail = value,
                controller: TextEditingController(text: userEmail),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Bio"),
                onChanged: (value) => newBio = value,
                controller: TextEditingController(text: userBio),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userName = newName ?? userName;
                  userEmail = newEmail ?? userEmail;
                  userBio = newBio ?? userBio;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
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
       // Debugging
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/edu-vista-71bae.appspot.com/o/images%2Fphoto_2024-06-11_00-15-05.jpg')),
              InkWell(
                onTap: uploadImage, // Call the upload function when tapped
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: ColorUtility.main,
                  backgroundImage: downloadUrl.isNotEmpty
                      ? NetworkImage(downloadUrl.trim()) // Trim any whitespace
                      : null,
                  child: downloadUrl.isEmpty
                      ? Icon(Icons.person,
                          size: 50, color: Colors.white) // Placeholder icon
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Text(
                userName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                userEmail,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                userBio,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: editProfile,
                child: Text("Edit Profile"),
              ),
              SizedBox(height: 20),
              // Add the image widget to test loading
        
            ],
          ),
        ),
      ),
    );
  }
}
