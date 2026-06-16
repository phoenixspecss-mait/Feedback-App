class FeedbackEntry {
  final int? id;
  final String deviceOwner;
  final String userName;
  final String userEmail;
  final String userContact;
  final String bugDescription;
  final String userDevice;
  final String mediaLinks;
  final String createdAt;

  FeedbackEntry({
    this.id,
    required this.deviceOwner,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.bugDescription,
    required this.userDevice,
    this.mediaLinks = '',
    required this.createdAt,
  });

  factory FeedbackEntry.fromMap(Map<String, dynamic> map) => FeedbackEntry(
    id: map['id'],
    deviceOwner: map['device_owner'],
    userName: map['user_name'],
    userEmail: map['user_email'],
    userContact: map['user_contact'],
    bugDescription: map['bug_description'],
    userDevice: map['user_device'],
    mediaLinks: map['media_links'] ?? '',
    createdAt: map['created_at'],
  );
}
