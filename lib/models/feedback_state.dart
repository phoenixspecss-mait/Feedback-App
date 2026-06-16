import 'package:Feedback_App/models/feedback_entry.dart';

abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}
class FeedbackLoading extends FeedbackState {}
class FeedbackLoaded extends FeedbackState {
  final List<FeedbackEntry> feedbackList;
  FeedbackLoaded(this.feedbackList);
}
class FeedbackSubmitted extends FeedbackState {}
class FeedbackError extends FeedbackState {
  final String message;
  FeedbackError(this.message);
}
