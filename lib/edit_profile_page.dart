import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();

  late User _currentUser;
  String _fullName = '';
  String _gender = '';
  String _birthdate = '';
  String _phoneNumber = '';
  String _email = '';
  String _username = '';
  File? _image;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(_currentUser.uid).get();
    setState(() {
      _fullName = userDoc['fullName'] ?? "";
      _gender = userDoc['gender'] ?? "";
      _birthdate = userDoc['birthdate'] ?? "";
      _phoneNumber = userDoc['phoneNumber'] ?? "";
      _email = userDoc['email'] ?? "";
      _username = userDoc['username'] ?? "";
      _currentImageUrl = userDoc['profilePictureUrl'];
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String? profilePictureUrl = _currentImageUrl;
        if (_image != null) {
          Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/${_currentUser.uid}');
          UploadTask uploadTask = ref.putFile(_image!);
          TaskSnapshot taskSnapshot = await uploadTask;
          profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
        }

        await _firestore.collection('users').doc(_currentUser.uid).update({
          'fullName': _fullName,
          'gender': _gender,
          'birthdate': _birthdate,
          'phoneNumber': _phoneNumber,
          'email': _email,
          'username': _username,
          'profilePictureUrl': profilePictureUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildTextField(String label, String value, void Function(String?) onSaved, {bool readOnly = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        initialValue: value,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSaved: onSaved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (_currentImageUrl != null
                          ? NetworkImage(_currentImageUrl!)
                          : null) as ImageProvider<Object>?,
                      child: (_image == null && _currentImageUrl == null)
                          ? Icon(Icons.person, size: 50, color: Colors.grey[800])
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: getImage,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _fullName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '@$_username',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                _buildTextField('Full name', _fullName, (value) => _fullName = value!),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Gender', _gender, (value) => _gender = value!)),
                    SizedBox(width: 16),
                    Expanded(child: _buildTextField('Birthday', _birthdate, (value) => _birthdate = value!)),
                  ],
                ),
                _buildTextField('Phone number', _phoneNumber, (value) => _phoneNumber = value!),
                _buildTextField('Email', _email, (value) => _email = value!, readOnly: true),
                _buildTextField('User name', _username, (value) => _username = value!),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Save'),
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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