import 'package:Feedback_App/enums/menu_action.dart';
import 'package:Feedback_App/services/auth/auth_service.dart';
import 'package:Feedback_App/views/notes_view.dart';
import 'package:Feedback_App/views/profile_view.dart';
import 'package:Feedback_App/views/user_details_screen.dart';
import 'package:flutter/material.dart';

class app_shell extends StatefulWidget {
  final int initialIndex;
  const app_shell({super.key, this.initialIndex = 0});

  @override
  State<app_shell> createState() => _app_shellState();
}

class _app_shellState extends State<app_shell> {
  late int _currentindex;

  @override
  void initState() {
    super.initState();
    _currentindex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    notesView(),
    profile_view(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Feedback App'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<MenuAction>(
            color: Colors.white,
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showlogoutdialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().Logout();
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log Out', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentindex,
        selectedItemColor: Colors.purple,
        onTap: (index) => setState(() => _currentindex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _currentindex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const user_details_screen()),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
