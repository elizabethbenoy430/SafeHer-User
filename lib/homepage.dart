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

      // 🔝 APP BAR
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const UserLoginPage()),
                );
              },
            ),
          ),
        ],
      ),

      // 🧍 HOME CONTENT
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
              const SizedBox(height: 35),

              // 🚨 SOS BUTTON
              const Center(child: GlowingSOSButton()),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "EMERGENCY SOS",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 35),

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

      // 🔽 BOTTOM NAV
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

// 🔴 ATTRACTIVE SOS BUTTON
class GlowingSOSButton extends StatefulWidget {
  const GlowingSOSButton({super.key});

  @override
  State<GlowingSOSButton> createState() => _GlowingSOSButtonState();
}

class _GlowingSOSButtonState extends State<GlowingSOSButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 0, end: 25).animate(_pulseController);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: _pulseAnimation.value,
                      spreadRadius: _pulseAnimation.value,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: SOS logic
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(45),
                  elevation: 12,
                  backgroundColor: Colors.redAccent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.warning_rounded,
                        color: Colors.white, size: 36),
                    SizedBox(height: 4),
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
            ],
          ),
        );
      },
    );
  }
}
