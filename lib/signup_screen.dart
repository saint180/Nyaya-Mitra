import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'home_page.dart';
import 'edit_profile_page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _fullName = '';
  String _email = '';
  String _password = '';
  String _dateOfBirth = '';

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        String? profilePictureUrl;
        try {
          if (_image != null) {
            Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/${userCredential.user!.uid}');
            UploadTask uploadTask = ref.putFile(_image!);
            TaskSnapshot taskSnapshot = await uploadTask;
            profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
          }
        } catch (e) {
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: ${e.toString()}')),
          );
        }

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': _fullName,
          'email': _email,
          'dateOfBirth': _dateOfBirth,
          'profilePictureUrl': profilePictureUrl,
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from Gallery'),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a Photo'),
                                onTap: () {
                                  getImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[800])
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap to add profile picture',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                  onSaved: (value) => _fullName = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    suffixIcon: Icon(Icons.visibility, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Date of Birth',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.datetime,
                  validator: (value) => value!.isEmpty ? 'Please enter your date of birth' : null,
                  onSaved: (value) => _dateOfBirth = value!,
                ),
                const SizedBox(height: 20),
                Text(
                  'By selecting Agree and continue below, I agree to Terms of Service and Privacy Policy',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Agree and continue'),
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// service cloud.firestore {
// match /databases/{database}/documents {
//h
// // This rule allows anyone with your Firestore database reference to view, edit,
// // and delete all data in your Firestore database. It is useful for getting
// // started, but it is configured to expire after 30 days because it
// // leaves your app open to attackers. At that time, all client
// // requests to your Firestore database will be denied.
// //
// // Make sure to write security rules for your app before that time, or else
// // all client requests to your Firestore database will be denied until you Update
// // your rules
// match /{document=**} {
// allow read, write: if request.time < timestamp.date(2024, 11, 17);
// }
// }
// }