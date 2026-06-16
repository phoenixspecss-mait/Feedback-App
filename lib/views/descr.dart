import 'package:Feedback_App/models/feedback_bloc.dart';
import 'package:Feedback_App/models/feedback_event.dart';
import 'package:Feedback_App/models/feedback_state.dart';
import 'package:Feedback_App/models/service_locator.dart';
import 'package:Feedback_App/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class description_view extends StatefulWidget {
  const description_view({super.key});

  @override
  State<description_view> createState() => _description_viewState();
}

class _description_viewState extends State<description_view> {
  final _userName = TextEditingController();
  final _userEmail = TextEditingController();
  final _userContact = TextEditingController();
  final _bugDescription = TextEditingController();
  final _userDevice = TextEditingController();
  late final FeedbackBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<FeedbackBloc>();
  }

  @override
  void dispose() {
    _userName.dispose();
    _userEmail.dispose();
    _userContact.dispose();
    _bugDescription.dispose();
    _userDevice.dispose();
    _bloc.close();
    super.dispose();
  }

  void _submit() {
    if (_userName.text.isEmpty ||
        _userEmail.text.isEmpty ||
        _userContact.text.isEmpty ||
        _bugDescription.text.isEmpty ||
        _userDevice.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
      );
      return;
    }
    final owner = AuthService.firebase().currentUser;
    _bloc.add(SubmitFeedbackEvent(
      deviceOwner: owner?.id ?? 'unknown',
      userName: _userName.text.trim(),
      userEmail: _userEmail.text.trim(),
      userContact: _userContact.text.trim(),
      bugDescription: _bugDescription.text.trim(),
      userDevice: _userDevice.text.trim(),
    ));
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is FeedbackSubmitted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Thank You!'),
              content: const Text('Feedback submitted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        if (state is FeedbackError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Submit Feedback'),
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
              const Text('User Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildField(_userName, 'Your Name', Icons.person_outline),
              const SizedBox(height: 12),
              _buildField(_userEmail, 'Your Email', Icons.email_outlined,
                  keyboard: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildField(_userContact, 'Your Contact', Icons.phone_outlined,
                  keyboard: TextInputType.phone),
              const SizedBox(height: 20),
              const Text('Bug Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _buildField(_userDevice, 'Device (e.g. Samsung Galaxy S21)',
                  Icons.phone_android_outlined),
              const SizedBox(height: 12),
              _buildField(_bugDescription, 'Describe the bug...',
                  Icons.bug_report_outlined, maxLines: 5),
              const SizedBox(height: 30),
              BlocBuilder<FeedbackBloc, FeedbackState>(
                bloc: _bloc,
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: state is FeedbackLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                        : ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Submit Feedback',
                                style: TextStyle(fontSize: 16)),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
