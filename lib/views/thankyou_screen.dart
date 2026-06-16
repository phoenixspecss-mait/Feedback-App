import 'dart:async';
import 'package:Feedback_App/views/user_details_screen.dart';
import 'package:flutter/material.dart';

class thankyou_screen extends StatefulWidget {
  const thankyou_screen({super.key});

  @override
  State<thankyou_screen> createState() => _thankyou_screenState();
}

class _thankyou_screenState extends State<thankyou_screen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const user_details_screen()),
          (route) => route.isFirst,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE7F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: Colors.purple, size: 60),
            ),
            const SizedBox(height: 24),
            const Text('Thank You!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Your feedback has been submitted successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('Redirecting to new entry...',
                style: TextStyle(fontSize: 13, color: Colors.black38)),
          ],
        ),
      ),
    );
  }
}
