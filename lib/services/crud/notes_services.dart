import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

@immutable
class databaseuser {
  final int id;
  final String email;
  const databaseuser({required this.id, required this.email});

  databaseuser.fromRow(Map<String, Object?> map)
    : id = map[idcolumn] as int,
      email = map[emailcolumn] as String;

    @override
    String tostring() => 'Person, ID = $id, email = $email';

    @override bool operator == (covariant databaseuser other) => id == other.id;
}

const idcolumn = 'id';
const emailcolumn = 'email';
