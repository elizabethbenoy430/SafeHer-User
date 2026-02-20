import 'package:flutter/material.dart';
import 'package:user_app/addcrime.dart';



class Crime extends StatefulWidget {
  const Crime({super.key});

  @override
  State<Crime> createState() => _CrimeState();
}

class _CrimeState extends State<Crime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crime Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // View Crime Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCrime()),
                );
              },
              child: const Text("Add Crime"),
            ),

            const SizedBox(height: 20),

            // Add Crime Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCrime()),
                );
              },
              child: const Text("Add Crime"),
            ),
          ],
        ),
      ),
    );
  }
}