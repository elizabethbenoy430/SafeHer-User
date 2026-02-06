import 'package:flutter/material.dart';
import 'package:user_app/login.dart';
import 'package:user_app/myprofile.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  // FEATURE CARD
  Widget featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.black, size: 28),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
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

      // 🔝 APP BAR (NO DRAWER)
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield, color: Color(0xFF4CAF50), size: 22),
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Color(0xFF1E1E1E),
                child: Icon(Icons.logout_rounded, color: Colors.grey),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserLoginPage()),
                );
              },
            ),
          ),
        ],
      ),

      // 🧍 USER HOME CONTENT
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Stay Safe",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "AI-powered safety assistance at your fingertips",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // 🚨 SOS
              const Center(child: GlowingSOSButton()),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "EMERGENCY SOS",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              featureCard(
                icon: Icons.psychology,
                title: "AI Safety Prediction",
                subtitle: "Predicts unsafe areas using AI & data",
              ),
              const SizedBox(height: 16),
              featureCard(
                icon: Icons.location_on,
                title: "Live Location Sharing",
                subtitle: "Share live location with trusted contacts",
              ),
              const SizedBox(height: 16),
              featureCard(
                icon: Icons.contacts,
                title: "Emergency Contacts",
                subtitle: "Manage trusted contacts for SOS",
              ),
              const SizedBox(height: 16),
              featureCard(
                icon: Icons.report,
                title: "Incident Reporting",
                subtitle: "Report suspicious activities instantly",
              ),
              const SizedBox(height: 16),
              featureCard(
                icon: Icons.notifications,
                title: "Safety Alerts",
                subtitle: "Receive real-time safety notifications",
              ),
              const SizedBox(height: 16),
              featureCard(
                icon: Icons.history,
                title: "SOS History",
                subtitle: "View previous SOS activity & tracking",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // 🔽 BOTTOM NAVIGATION (PROFILE → MyProfile)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyProfile()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "SOS"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// 🔴 GLOWING SOS BUTTON
class GlowingSOSButton extends StatefulWidget {
  const GlowingSOSButton({super.key});

  @override
  State<GlowingSOSButton> createState() => _GlowingSOSButtonState();
}

class _GlowingSOSButtonState extends State<GlowingSOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.6),
                blurRadius: _animation.value,
                spreadRadius: _animation.value / 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Trigger SOS
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(50),
              elevation: 8,
            ),
            child: const Icon(
              Icons.warning,
              size: 55,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
