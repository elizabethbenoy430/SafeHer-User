import 'package:flutter/material.dart';
import 'package:user_app/login.dart';
import 'package:user_app/myprofile.dart';

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
          color: const Color(0xFF181818),
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

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield_rounded,
                color: Color(0xFF4CAF50), size: 22),
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

      // 🔥 BACKGROUND GRADIENT ADDED HERE
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF061912), // deep green-black
              Color(0xFF000000), // pure black
            ],
          ),
        ),
        child: SafeArea(
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

                // SOS ZONE (UNCHANGED)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 30, horizontal: 20),
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
                        style:
                            TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                featureCard(
                  icon: Icons.psychology,
                  title: "AI Safety Prediction",
                  subtitle: "Predict unsafe areas using AI",
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
                  title: "Emergency Contacts",
                  subtitle: "Manage SOS contacts",
                ),
                const SizedBox(height: 16),
                featureCard(
                  icon: Icons.report,
                  title: "Incident Reporting",
                  subtitle: "Report suspicious activities",
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),

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

// SOS BUTTON (UNCHANGED)
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
    _pulse =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
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
              // TODO: SOS logic
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
                Icon(Icons.warning_rounded,
                    color: Colors.white, size: 38),
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
