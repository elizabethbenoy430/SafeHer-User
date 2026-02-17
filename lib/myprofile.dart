import 'package:flutter/material.dart';
import 'package:user_app/changepassword.dart';
import 'package:user_app/editprofile.dart';
import 'package:user_app/userregistration.dart';
import 'editprofile.dart';
import 'changepassword.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

      if (!mounted) return;

      setState(() {
        userData = response.isNotEmpty ? response[0] : null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching profile: $e")),
      );
    }
  }

  Widget infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.15),
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20),
              Colors.black,
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // PROFILE CARD
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Colors.green.withOpacity(0.4)),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor:
                                  Colors.green.withOpacity(0.2),
                              backgroundImage:
                                  (userData?['user_photo'] != null &&
                                          userData!['user_photo']
                                              .toString()
                                              .isNotEmpty)
                                      ? NetworkImage(userData!['user_photo'])
                                      : null,
                              child: (userData?['user_photo'] == null ||
                                      userData!['user_photo']
                                          .toString()
                                          .isEmpty)
                                  ? const Icon(Icons.person,
                                      size: 50, color: Colors.green)
                                  : null,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              userData?['user_name'] ?? 'No Name',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userData?['user_email'] ?? 'No Email',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // INFO SECTION
                      infoCard(
                        "Phone Number",
                        userData?['user_contact'] ?? 'N/A',
                        Icons.phone,
                      ),
                      const SizedBox(height: 15),
                      infoCard(
                        "Date of Birth",
                        userData?['user_dob'] ?? 'N/A',
                        Icons.cake,
                      ),

                      const SizedBox(height: 35),

                      // EDIT PROFILE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfile()),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.black),
                          label: const Text(
                            "EDIT PROFILE",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // CHANGE PASSWORD BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePassword()),
                            );
                          },
                          icon: const Icon(Icons.lock_outline,
                              color: Color(0xFF4CAF50)),
                          label: const Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Color(0xFF4CAF50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
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
