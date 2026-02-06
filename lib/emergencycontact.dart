import 'package:flutter/material.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContact> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController relationController = TextEditingController();

  InputDecoration _inputStyle(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    relationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Emergency Contact",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                const Icon(Icons.contact_phone, size: 60, color: Color(0xFF4CAF50)),
                const SizedBox(height: 20),

                const Text(
                  "Add Emergency Contact",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                const Text(
                  "Enter details of a trusted person",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // NAME
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputStyle("Contact Name", icon: Icons.person),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Contact name is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // PHONE
                      TextFormField(
                        controller: phoneController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: _inputStyle("Contact Number", icon: Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Contact number is required";
                          }
                          if (value.length != 10) {
                            return "Enter a valid 10 digit number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // RELATION
                      TextFormField(
                        controller: relationController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputStyle("Relation (e.g. Father, Friend)", icon: Icons.group),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Relation is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // SUBMIT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Emergency Contact Added"),
                                  backgroundColor: Color(0xFF4CAF50),
                                ),
                              );

                              // TODO: Save to database / API
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.check, color: Colors.black),
                          label: const Text(
                            "SUBMIT",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
