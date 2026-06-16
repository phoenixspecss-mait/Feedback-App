import 'package:Feedback_App/models/feedback_bloc.dart';
import 'package:Feedback_App/models/feedback_event.dart';
import 'package:Feedback_App/models/feedback_state.dart';
import 'package:Feedback_App/models/service_locator.dart';
import 'package:Feedback_App/services/csv_export_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class notesView extends StatefulWidget {
  const notesView({super.key});

  @override
  State<notesView> createState() => _notesViewState();
}

class _notesViewState extends State<notesView> {
  late final FeedbackBloc _bloc;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<FeedbackBloc>();
    _bloc.add(LoadFeedbackEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _exportCSV() async {
    try {
      final bool canAuth = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (canAuth) {
        final bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Authenticate to export feedback data',
          options: const AuthenticationOptions(biometricOnly: false),
        );
        if (!authenticated) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Authentication failed'), backgroundColor: Colors.red),
            );
          }
          return;
        }
      }
      final path = await CsvExportService.exportToDownloads();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(path != null ? 'Exported to: $path' : 'Export failed'),
            backgroundColor: path != null ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _exportCSV,
              icon: const Icon(Icons.download_outlined, color: Colors.purple),
              label: const Text('Export CSV', style: TextStyle(color: Colors.purple)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<FeedbackBloc, FeedbackState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is FeedbackLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FeedbackLoaded) {
                if (state.feedbackList.isEmpty) {
                  return const Center(
                    child: Text(
                      'No feedback yet.\nTap + to add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => _bloc.add(LoadFeedbackEvent()),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.feedbackList.length,
                    itemBuilder: (context, index) {
                      final item = state.feedbackList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(item.userName,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE7F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(item.userDevice,
                                      style: const TextStyle(fontSize: 11, color: Colors.purple)),
                                ),
                              ]),
                              const SizedBox(height: 8),
                              Text(item.bugDescription,
                                  style: const TextStyle(color: Colors.black87)),
                              const SizedBox(height: 8),
                              Text(item.createdAt.substring(0, 10),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is FeedbackError) return Center(child: Text(state.message));
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

Future<bool> showlogoutdialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
