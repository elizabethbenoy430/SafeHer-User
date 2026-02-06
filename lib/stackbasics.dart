import 'package:flutter/material.dart';

class BasicStack extends StatefulWidget {
  const BasicStack({super.key});

  @override
  State<BasicStack> createState() => _BasicStackState();
}

class _BasicStackState extends State<BasicStack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue, 
            ),
          Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              color: Colors.red),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue
              ),
            )
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,

              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue
              ),
              child: Image.asset('assets/sos.jpg'),
            ),
          )
        ],
      ),
    );
  }
}