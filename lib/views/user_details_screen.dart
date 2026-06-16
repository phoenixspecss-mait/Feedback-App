import 'package:Feedback_App/views/bug_screen.dart';
import 'package:flutter/material.dart';

class user_details_screen extends StatefulWidget {
  const user_details_screen({super.key});

  @override
  State<user_details_screen> createState() => _user_details_screenState();
}

class _user_details_screenState extends State<user_details_screen> {
  final _userName = TextEditingController();
  final _userEmail = TextEditingController();
  final _userContact = TextEditingController();

  @override
  void dispose() {
    _userName.dispose();
    _userEmail.dispose();
    _userContact.dispose();
    super.dispose();
  }

  void _next() {
    if (_userName.text.isEmpty || _userEmail.text.isEmpty || _userContact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => bug_screen(
          userName: _userName.text.trim(),
          userEmail: _userEmail.text.trim(),
          userContact: _userContact.text.trim(),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Details'),
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
            const Text('Who is submitting feedback?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            _buildField(_userName, 'Your Name', Icons.person_outline),
            const SizedBox(height: 12),
            _buildField(_userEmail, 'Your Email', Icons.email_outlined,
                keyboard: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _buildField(_userContact, 'Your Contact', Icons.phone_outlined,
                keyboard: TextInputType.phone),
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
                child: const Text('Next', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
