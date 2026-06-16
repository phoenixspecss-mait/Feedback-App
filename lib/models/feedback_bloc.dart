import 'package:Feedback_App/models/feedback_entry.dart';
import 'package:Feedback_App/models/feedback_event.dart';
import 'package:Feedback_App/models/feedback_state.dart';
import 'package:Feedback_App/services/db/database_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<LoadFeedbackEvent>(_onLoad);
    on<SubmitFeedbackEvent>(_onSubmit);
  }

  Future<void> _onLoad(LoadFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackLoading());
    try {
      final data = await DatabaseService.instance.getAllFeedback();
      final list = data.map((e) => FeedbackEntry.fromMap(e)).toList();
      emit(FeedbackLoaded(list));
    } catch (e) {
      emit(FeedbackError('Failed to load feedback'));
    }
  }

  Future<void> _onSubmit(SubmitFeedbackEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackLoading());
    try {
      await DatabaseService.instance.saveFeedback(
        deviceOwner: event.deviceOwner,
        userName: event.userName,
        userEmail: event.userEmail,
        userContact: event.userContact,
        bugDescription: event.bugDescription,
        userDevice: event.userDevice,
        mediaLinks: event.mediaLinks,
      );
      emit(FeedbackSubmitted());
    } catch (e) {
      emit(FeedbackError('Failed to submit feedback'));
    }
  }
}
