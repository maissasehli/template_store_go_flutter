import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Form controllers
  final TextEditingController _fullNameController = TextEditingController(text: "Puerto Rico");
  final TextEditingController _userNameController = TextEditingController(text: "puerto_rico");
  final TextEditingController _emailController = TextEditingController(text: "youremail@domain.com");
  final TextEditingController _phoneController = TextEditingController(text: "+216 25 236 589");
  String _selectedCountry = "Tunisia";
  String _selectedGender = "Female";

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Profile Image
              _buildProfileImage(),
              const SizedBox(height: 16),
              // Profile Name
              Text(
                'Keira Knightley',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                '@keirakn',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              // Form Fields
              _buildFormFields(),
              const SizedBox(height: 24),
              // Save Button
              _buildSaveButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 100.87,
          height: 100.87,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(77),
            border: Border.all(
              color: Colors.purple.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(77),
            child: Image.asset(
              'assets/images/profile_avatar.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.purple,
          child: Icon(
            Icons.camera_alt,
            size: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildFormField(
          label: 'Full name',
          value: _fullNameController.text,
          onChanged: (value) => _fullNameController.text = value,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'Nick name',
          value: _userNameController.text,
          onChanged: (value) => _userNameController.text = value,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'Email',
          value: _emailController.text,
          onChanged: (value) => _emailController.text = value,
        ),
        const SizedBox(height: 16),
        _buildPhoneField(),
        const SizedBox(height: 16),
        _buildDropdownRow(),
      ],
    );
  }

Widget _buildFormField({
  required String label,
  required String value,
  required Function(String) onChanged,
}) {
  return Container(
    width: 342,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: InputBorder.none,
          focusColor: Colors.transparent,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 16/10,
            letterSpacing: 0.25,
            color: Color(0xFF757575),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(top: 8, bottom: 0),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 18/14,
          letterSpacing: 0.25,
        ),
        cursorColor: Colors.grey,
      ),
    ),
  );
}

  Widget _buildPhoneField() {
    return Container(
      width: 342,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.phone,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Theme(
              // This removes the default focus highlighting
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  focusedBorder: InputBorder.none,
                  focusColor: Colors.transparent,
                ),
                // Remove the splash effect when tapping
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16/10, // Line height
                    letterSpacing: 0.25,
                    color: Color(0xFF757575), // Light/Gray-7
                  ),
          contentPadding: const EdgeInsets.only(top: 8, bottom: 0),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 18/14, // Line height
                  letterSpacing: 0.25,
                ),
                cursorColor: Colors.grey, // Changes cursor color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCountry,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['Tunisia', 'USA', 'Canada', 'UK', 'France'].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  }
                },
                hint: Text(
                  'Country',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['Male', 'Female', 'Other'].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedGender = value;
                    });
                  }
                },
                hint: Text(
                  'Gender',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: 342,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: () {
          // Implement save functionality
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}