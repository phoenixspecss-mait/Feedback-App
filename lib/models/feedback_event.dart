abstract class FeedbackEvent {}

class LoadFeedbackEvent extends FeedbackEvent {}

class SubmitFeedbackEvent extends FeedbackEvent {
  final String deviceOwner;
  final String userName;
  final String userEmail;
  final String userContact;
  final String bugDescription;
  final String userDevice;
  final String mediaLinks;

  SubmitFeedbackEvent({
    required this.deviceOwner,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.bugDescription,
    required this.userDevice,
    this.mediaLinks = '',
  });
}
