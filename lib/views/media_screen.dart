import 'dart:io';
import 'package:Feedback_App/models/feedback_bloc.dart';
import 'package:Feedback_App/models/feedback_event.dart';
import 'package:Feedback_App/models/feedback_state.dart';
import 'package:Feedback_App/models/service_locator.dart';
import 'package:Feedback_App/services/auth/auth_service.dart';
import 'package:Feedback_App/views/thankyou_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class media_screen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userContact;
  final String bugDescription;
  final String userDevice;

  const media_screen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.bugDescription,
    required this.userDevice,
  });

  @override
  State<media_screen> createState() => _media_screenState();
}

class _media_screenState extends State<media_screen> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  late final FeedbackBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<FeedbackBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _pickGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedImages.add(File(image.path)));
  }

  Future<void> _pickCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) setState(() => _selectedImages.add(File(image.path)));
  }

  void _submit() {
    final owner = AuthService.firebase().currentUser;
    final mediaLinks = _selectedImages.map((f) => f.path).join(',');
    _bloc.add(SubmitFeedbackEvent(
      deviceOwner: owner?.id ?? 'unknown',
      userName: widget.userName,
      userEmail: widget.userEmail,
      userContact: widget.userContact,
      bugDescription: widget.bugDescription,
      userDevice: widget.userDevice,
      mediaLinks: mediaLinks,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is FeedbackSubmitted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const thankyou_screen()),
            (route) => route.isFirst,
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
          title: const Text('Attach Media'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attach Screenshots / Images',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Optional — attach media related to the bug.',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickGallery,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickCamera,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Camera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedImages.isNotEmpty) ...[
                Text('${_selectedImages.length} image(s) selected',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    itemCount: _selectedImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity),
                          ),
                          Positioned(
                            top: 4, right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedImages.removeAt(index)),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ] else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_outlined, size: 60, color: Colors.black26),
                        SizedBox(height: 12),
                        Text('No images selected', style: TextStyle(color: Colors.black45)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              BlocBuilder<FeedbackBloc, FeedbackState>(
                bloc: _bloc,
                builder: (context, state) => SizedBox(
                  width: double.infinity,
                  child: state is FeedbackLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Submit Feedback', style: TextStyle(fontSize: 16)),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
