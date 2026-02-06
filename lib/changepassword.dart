import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}




class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController retypePasswordController = TextEditingController();

  bool _oldObscure = true;
  bool _newObscure = true;
  bool _retypeObscure = true;

  // Password validation: Min 8 chars, 1 capital, 1 number
  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }

  InputDecoration inputStyle(String hint, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
    required String? Function(String?) validator,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: inputStyle(
          label,
          icon: icon,
          suffix: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: toggle,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.lock_outline, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, color: Color(0xFF4CAF50), size: 60),
                const SizedBox(height: 20),
                const Text(
                  "Securely update your password",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Password Fields
                passwordField(
                  label: "Old Password",
                  controller: oldPasswordController,
                  obscureText: _oldObscure,
                  toggle: () => setState(() => _oldObscure = !_oldObscure),
                  validator: (value) => value == null || value.isEmpty ? "Old password required" : null,
                  icon: Icons.lock_outline,
                ),
                passwordField(
                  label: "New Password",
                  controller: newPasswordController,
                  obscureText: _newObscure,
                  toggle: () => setState(() => _newObscure = !_newObscure),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "New password required";
                    if (!isValidPassword(value)) return "Min 8 chars, 1 capital & 1 number";
                    return null;
                  },
                  icon: Icons.fiber_new,
                ),
                passwordField(
                  label: "Retype Password",
                  controller: retypePasswordController,
                  obscureText: _retypeObscure,
                  toggle: () => setState(() => _retypeObscure = !_retypeObscure),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please retype password";
                    if (value != newPasswordController.text) return "Passwords do not match";
                    return null;
                  },
                  icon: Icons.repeat,
                ),

                const SizedBox(height: 30),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password changed successfully"),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.update, color: Colors.black),
                    label: const Text(
                      "UPDATE PASSWORD",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
