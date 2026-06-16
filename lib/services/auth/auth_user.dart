import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVeified;
  const AuthUser({required this.isEmailVeified,required this.id});

  factory AuthUser.fromFirebase(User user) => 
  AuthUser(
    isEmailVeified: user.emailVerified,
    id: user.uid
  );

}