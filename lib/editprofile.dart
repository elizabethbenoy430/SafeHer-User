import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  final supabase = Supabase.instance.client;
  bool isUpdating = false;


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // 🔹 LOAD USER DATA FROM SUPABASE
  Future<void> loadUserData() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', userId)
          .single();

      setState(() {
        nameController.text = response['user_name'] ?? "";
        emailController.text = response['user_email'] ?? "";
        phoneController.text = response['user_contact'] ?? "";
        addressController.text = response['user_address'] ?? "";
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Load error: $e");
    }
  }

  // 🔹 INPUT FIELD UI
  Widget inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.grey),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // 🔹 UPDATE PROFILE FUNCTION
  Future<void> updateProfile() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => isUpdating = true); // 🔥 LOADER START

  try {
    final userId = supabase.auth.currentUser!.id;

    await supabase.from('tbl_user').update({
      'user_name': nameController.text.trim(),
      'user_email': emailController.text.trim(),
      'user_contact': phoneController.text.trim(),
      'user_address': addressController.text.trim(),
    }).eq('user_id', userId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated Successfully"),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );

    Navigator.pop(context, true); // ✅ RETURN TRUE TO RELOAD PROFILE

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Update Failed: $e"),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) setState(() => isUpdating = false); // 🔥 LOADER STOP
  }
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
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
       body: (isLoading || isUpdating)

          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // PROFILE ICON
                      
                      const SizedBox(height: 40),

                      // NAME
                      inputField(
                        label: "Name",
                        icon: Icons.person,
                        controller: nameController,
                        validator: (v) =>
                            v!.isEmpty ? "Enter name" : null,
                      ),

                      // EMAIL
                      inputField(
                        label: "Email",
                        icon: Icons.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v!.isEmpty) return "Enter email";
                          if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                              .hasMatch(v)) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),

                      // PHONE
                      inputField(
                        label: "Contact Number",
                        icon: Icons.phone,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v!.isEmpty) return "Enter phone";
                          if (v.length != 10) return "Enter 10 digit number";
                          return null;
                        },
                      ),

                      // ADDRESS
                      inputField(
                        label: "Address",
                        icon: Icons.location_on,
                        controller: addressController,
                        maxLines: 3,
                        validator: (v) =>
                            v!.isEmpty ? "Enter address" : null,
                      ),

                      const SizedBox(height: 40),

                      // UPDATE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "UPDATE",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
