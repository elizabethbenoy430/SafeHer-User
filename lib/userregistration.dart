import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_app/login.dart';

final supabase = Supabase.instance.client;

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  DateTime? _selectedDob;
  bool _obscurePassword = true;
  bool _isLoading = false;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  // ---------------- INPUT STYLE ----------------
  InputDecoration _inputStyle(String hint,
      {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  // ---------------- IMAGE PICKER ----------------
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Colors.green),
              title: const Text("Photo Library",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text("Camera",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (_) {
      _showError("Image picking failed");
    }
  }

  // ---------------- DATE PICKER ----------------
  Future<void> _pickDob() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme:
                const ColorScheme.dark(primary: Color(0xFF4CAF50)),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  // ---------------- SUCCESS DIALOG ----------------
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                "Registration Completed!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Check your email to verify your account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- REGISTER ----------------
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDob == null) {
      _showError("Please select Date of Birth");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user == null) throw "Registration failed";

      String? photoUrl;

      if (_imageFile != null) {
        final path =
            'UserPhoto/${res.user!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage.from('UserPhoto').upload(path, _imageFile!);
        photoUrl =
            supabase.storage.from('UserPhoto').getPublicUrl(path);
      }

      await supabase.from('tbl_user').insert({
        'user_id': res.user!.id,
        'user_name': nameController.text.trim(),
        'user_email': email,
        'user_contact': phoneController.text.trim(),
        'user_dob': _selectedDob!.toIso8601String(),
        'user_photo': photoUrl,
        'user_password': password,
      });

      if (mounted) {
        _showSuccessDialog();
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserLoginPage(),));


      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF0F2027)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showPickerOptions,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFF1E1E1E),
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.add_a_photo,
                                color: Colors.greenAccent, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _sectionTitle("Personal Details"),
                            const SizedBox(height: 20),
                            _field(nameController, "Full Name", Icons.person),
                            _field(emailController, "Email", Icons.email),
                            _field(phoneController, "Phone Number", Icons.phone),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickDob,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.cake, color: Colors.grey),
                                    const SizedBox(width: 15),
                                    Text(
                                      _selectedDob == null
                                          ? "Date of Birth"
                                          : "${_selectedDob!.toLocal()}"
                                              .split(' ')[0],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputStyle(
                                "Password",
                                icon: Icons.lock,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() =>
                                        _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                              validator: (v) =>
                                  v!.length < 6 ? "Minimum 6 characters" : null,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "REGISTER",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _field(
      TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: _inputStyle(hint, icon: icon),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
