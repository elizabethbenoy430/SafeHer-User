import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_app/addcrime.dart';
import 'package:user_app/viewcrime.dart';

class Crime extends StatefulWidget {
  const Crime({super.key});

  @override
  State<Crime> createState() => _CrimeState();
}

class _CrimeState extends State<Crime> {
  final supabase = Supabase.instance.client;

  int totalReports = 0;
  int todayReports = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCrimeStats();
  }

  // ================= FETCH DATA =================
  Future<void> fetchCrimeStats() async {
    try {
      // TOTAL COUNT
      final totalResponse = await supabase
          .from('tbl_crime')
          .select('*')
          .count();

      // TODAY COUNT (for TIMESTAMP)
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final end = start.add(const Duration(days: 1));

      final todayResponse = await supabase
          .from('tbl_crime')
          .select('*')
          .gte('crime_date', start.toIso8601String())
          .lt('crime_date', end.toIso8601String())
          .count();

      setState(() {
        totalReports = totalResponse.count ?? 0;
        todayReports = todayResponse.count ?? 0;
        isLoading = false;
      });

      print("Total: $totalReports | Today: $todayReports");

    } catch (e) {
      print("ERROR FETCHING DATA: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  // ==============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.security, color: Colors.greenAccent),
            SizedBox(width: 8),
            Text(
              "Crime Report",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.greenAccent, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.black, size: 35),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stay Safe",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Report and track crime incidents",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // STATS CARDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statBox("Total Reports", totalReports.toString(), Icons.assignment),
                  _statBox("Today Reports", todayReports.toString(), Icons.today),
                ],
              ),

              const SizedBox(height: 30),

              // ACTION TITLE
              Row(
                children: const [
                  Icon(Icons.dashboard, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Actions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ADD CRIME
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCrime()),
                  );
                },
                child: _actionCard(
                  icon: Icons.add_alert,
                  title: "Add Crime Report",
                  color: Colors.greenAccent,
                ),
              ),

              const SizedBox(height: 20),

              // VIEW CRIME
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ViewCrime()),
                  );
                },
                child: _actionCard(
                  icon: Icons.visibility,
                  title: "View Crime Reports",
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // STAT BOX
  Widget _statBox(String title, String count, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 28),
          const SizedBox(height: 5),

          isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // ACTION CARD
  Widget _actionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}