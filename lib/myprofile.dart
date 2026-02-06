
import 'package:flutter/material.dart';
import 'package:user_app/userregistration.dart';

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

  Widget infoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
      
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            )
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // PROFILE IMAGE
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFF1E1E1E),
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
                                size: 50, color: Colors.grey)
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
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // INFO TILES
                      infoTile(
                        "Phone Number",
                        userData?['user_contact'] ?? 'N/A',
                        Icons.phone,
                      ),
                      infoTile(
                        "Date of Birth",
                        userData?['user_dob'] ?? 'N/A',
                        Icons.cake,
                      ),

                      const SizedBox(height: 40),

                      // BUTTONS
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Edit Profile
                          },
                          icon:
                              const Icon(Icons.edit, color: Colors.black),
                          label: const Text(
                            "EDIT PROFILE",
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Change Password
                          },
                          icon: const Icon(Icons.lock_outline,
                              color: Color(0xFF4CAF50)),
                          label: const Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF4CAF50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
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
