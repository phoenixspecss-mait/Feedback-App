import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Feedback_App/services/auth/auth_exceptions.dart';
import 'package:Feedback_App/services/auth/auth_service.dart';

class Register_Login_View extends StatefulWidget {
  const Register_Login_View({super.key});

  @override
  State<Register_Login_View> createState() => _Feedback_AppState();
}

class _Feedback_AppState extends State<Register_Login_View> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _loading = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.lock_outline, color: Colors.white),
          const SizedBox(width: 10),
          Text(msg),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
    ));
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      await AuthService.firebase().signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home/', (_) => false);
      }
    } on GoogleSignInCancelledException {
    } on GenericAuthException {
      _showSnack("Google Sign-In failed. Try again.", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleSubmit() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Please enter email and password", Colors.red);
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.firebase().createUser(email: email, password: password);
      _showSnack("Registered successfully!", Colors.green);
      await AuthService.firebase().sendEmailVerification();
      _showSnack("Verification email sent!", Colors.green);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VerifyEmailView()),
        );
      }
    } on EmailAlreadyInUseException {
      try {
        await AuthService.firebase().logIn(email: email, password: password);
        await AuthService.firebase().getupdateduser();
        final user = AuthService.firebase().currentUser;
        if (user?.isEmailVeified ?? false) {
          _showSnack("Welcome back!", Colors.green);
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/home/', (_) => false);
          }
        } else {
          await AuthService.firebase().Logout();
          _showSnack("Please verify your email first.", Colors.orange);
        }
      } on WrongPassAuthException {
        _showSnack("Incorrect password. Try again.", Colors.redAccent);
      } on GenericAuthException {
        _showSnack("Invalid credentials. Please try again.", Colors.redAccent);
      }
    } on WeakPassowrdExcetion {
      _showSnack("Password must be at least 6 characters.", Colors.redAccent);
    } on InvalidEmailException {
      _showSnack("Please enter a valid email.", Colors.redAccent);
    } catch (_) {
      _showSnack("Something went wrong. Try again.", Colors.red);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Text(
              "Your opinion means gold for us !",
              style: TextStyle(fontFamily: 'medifont2', fontSize: 20),
            ),
            Padding(padding: const EdgeInsets.all(15)),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
                Text("Login or Sign Up", style: TextStyle()),
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.all(15)),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8)),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(10)),
            _loading
                ? const CircularProgressIndicator(color: Colors.blue)
                : TextButton(
                    onPressed: _handleSubmit,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Log In'),
                  ),
            Padding(padding: const EdgeInsets.all(5)),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
                Text("OR", style: TextStyle()),
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.all(10)),
            GestureDetector(
              onTap: _loading ? null : _signInWithGoogle,
              child: Container(
                width: 310,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/image2.png',
                      height: 30,
                      width: 50,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(20)),
          ],
        ),
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => _checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    await AuthService.firebase().getupdateduser();
    final user = AuthService.firebase().currentUser;
    if (user?.isEmailVeified ?? false) {
      _timer?.cancel();
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home/', (_) => false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Checking your verification status...',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Please click the link in the email we sent to you.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}