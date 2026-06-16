import 'package:Feedback_App/models/feedback_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerFactory<FeedbackBloc>(() => FeedbackBloc());
}
