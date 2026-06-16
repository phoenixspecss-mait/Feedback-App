import 'package:Feedback_App/services/auth/auth_service.dart';
import 'package:Feedback_App/services/db/database_service.dart';
import 'package:flutter/material.dart';

class profile_view extends StatefulWidget {
  const profile_view({super.key});

  @override
  State<profile_view> createState() => _profile_viewState();
}

class _profile_viewState extends State<profile_view> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _contact = TextEditingController();
  bool _loading = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = AuthService.firebase().currentUser?.id;
    if (uid == null) return;
    final user = await DatabaseService.instance.getUser(uid);
    if (user != null) {
      _name.text = user['name'];
      _email.text = user['email'];
      _contact.text = user['contact'];
      setState(() => _saved = true);
    }
    setState(() => _loading = false);
  }

  Future<void> _saveProfile() async {
    final uid = AuthService.firebase().currentUser?.id;
    if (uid == null) return;
    if (_name.text.isEmpty || _email.text.isEmpty || _contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    await DatabaseService.instance.saveUser(
      uid: uid,
      name: _name.text.trim(),
      email: _email.text.trim(),
      contact: _contact.text.trim(),
    );
    setState(() => _saved = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(30)),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
          ),
          const Padding(padding: EdgeInsets.all(20)),
          _buildField(_name, 'Name', Icons.person_outline),
          const Padding(padding: EdgeInsets.all(12)),
          _buildField(_email, 'Email', Icons.email_outlined,
              keyboard: TextInputType.emailAddress),
          const Padding(padding: EdgeInsets.all(12)),
          _buildField(_contact, 'Phone No', Icons.phone_outlined,
              keyboard: TextInputType.phone),
          const Padding(padding: EdgeInsets.all(20)),
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(_saved ? 'Update Profile' : 'Save Profile'),
          ),
          const Padding(padding: EdgeInsets.all(20)),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {
    return SizedBox(
      width: 350,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: InputBorder.none, // Hides the default underline/border
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ),
    );
  }
}