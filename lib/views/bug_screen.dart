import 'package:Feedback_App/views/media_screen.dart';
import 'package:flutter/material.dart';

class bug_screen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userContact;

  const bug_screen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userContact,
  });

  @override
  State<bug_screen> createState() => _bug_screenState();
}

class _bug_screenState extends State<bug_screen> {
  final _bugDescription = TextEditingController();
  final _userDevice = TextEditingController();

  @override
  void dispose() {
    _bugDescription.dispose();
    _userDevice.dispose();
    super.dispose();
  }

  void _next() {
    if (_bugDescription.text.isEmpty || _userDevice.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => media_screen(
          userName: widget.userName,
          userEmail: widget.userEmail,
          userContact: widget.userContact,
          bugDescription: _bugDescription.text.trim(),
          userDevice: _userDevice.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bug Description'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Describe the bug',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _userDevice,
              decoration: InputDecoration(
                hintText: 'Device (e.g. Samsung Galaxy S21)',
                prefixIcon: const Icon(Icons.phone_android_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bugDescription,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Describe the bug or issue in detail...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Next: Attach Media', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
