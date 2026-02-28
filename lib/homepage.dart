import 'package:flutter/material.dart';
import 'package:user_app/addemergencycontact.dart';
import 'package:user_app/complaint.dart';
import 'package:user_app/crime.dart';
import 'package:user_app/login.dart';
import 'package:user_app/myemergencycontact.dart';
import 'package:user_app/myprofile.dart';
import 'package:user_app/chatbot.dart'; // Ensure this matches your filename

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  // CLASSY FEATURE CARD
  Widget featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF181818).withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white70,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white30,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // 🤖 CHATBOT FLOATING BUTTON - PLACED ON THE RIGHT
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 8,
        child: const Icon(Icons.forum_rounded, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Chatbot()),
          );
        },
      ),

      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield_rounded, color: Color(0xFF4CAF50), size: 22),
            SizedBox(width: 6),
            Text(
              "SafeHer",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF1E1E1E),
              child: Icon(Icons.logout_rounded, color: Colors.grey),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const UserLoginPage()),
              );
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.75),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Stay Safe",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "AI-powered safety assistance at your fingertips",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // 🔴 SOS ZONE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: [
                          Colors.redAccent.withOpacity(0.25),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      children: const [
                        GlowingSOSButton(),
                        SizedBox(height: 14),
                        Text(
                          "EMERGENCY SOS",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Press and hold in case of danger",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // 🤖 CHATBOT FEATURE CARD
                  featureCard(
                    icon: Icons.smart_toy_outlined,
                    title: "AI Safety Chatbot",
                    subtitle: "Instant help and safety guidance",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Chatbot()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  featureCard(
                    icon: Icons.location_on,
                    title: "Live Location Sharing",
                    subtitle: "Share location with trusted contacts",
                  ),

                  const SizedBox(height: 16),

                  featureCard(
                    icon: Icons.contacts,
                    title: "Add Emergency Contact",
                    subtitle: "Register new SOS contacts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EmergencyContact()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  featureCard(
                    icon: Icons.contact_phone_outlined,
                    title: "View Emergency Contacts",
                    subtitle: "Manage emergency contacts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyEmergencyContact()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  featureCard(
                    icon: Icons.notifications,
                    title: "Safety Alerts",
                    subtitle: "Get real-time alerts",
                  ),

                  const SizedBox(height: 16),

                  featureCard(
                    icon: Icons.history,
                    title: "SOS History",
                    subtitle: "View previous SOS activity",
                  ),

                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, 
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) return;

          Widget nextPage;
          switch (index) {
            case 1: nextPage = const Crime(); break;
            case 3: nextPage = const Complaint(); break;
            case 4: nextPage = const MyProfile(); break;
            default: return;
          }

          Navigator.push(context, MaterialPageRoute(builder: (_) => nextPage));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_police), label: "Crime"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "SOS"),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Complaint"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// 🔴 SOS BUTTON COMPONENT
class GlowingSOSButton extends StatefulWidget {
  const GlowingSOSButton({super.key});

  @override
  State<GlowingSOSButton> createState() => _GlowingSOSButtonState();
}

class _GlowingSOSButtonState extends State<GlowingSOSButton>
    with TickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _glow = Tween<double>(begin: 12, end: 30).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.6),
                blurRadius: _glow.value,
                spreadRadius: _glow.value / 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // SOS logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(48),
              elevation: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.warning_rounded, color: Colors.white, size: 38),
                SizedBox(height: 6),
                Text(
                  "SOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}