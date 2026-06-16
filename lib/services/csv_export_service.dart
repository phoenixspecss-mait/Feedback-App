import 'dart:io';
import 'package:Feedback_App/services/db/database_service.dart';
import 'package:path_provider/path_provider.dart';

class CsvExportService {
  static Future<String?> exportToDownloads() async {
    try {
      final feedbackList = await DatabaseService.instance.getAllFeedback();
      final buffer = StringBuffer();
      buffer.writeln('Device Owner,User Name,User Email,User Contact,Bug/Issue,User Device,Description and Media Links,Created At');
      for (final item in feedbackList) {
        buffer.writeln(
          '"${item['device_owner']}","${item['user_name']}","${item['user_email']}","${item['user_contact']}","${item['bug_description']}","${item['user_device']}","${item['media_links']}","${item['created_at']}"'
        );
      }
      final dir = await getExternalStorageDirectory();
      final path = '${dir?.path ?? '/storage/emulated/0/Download'}/feedback_export.csv';
      final file = File(path);
      await file.writeAsString(buffer.toString());
      return path;
    } catch (e) {
      return null;
    }
  }
}
