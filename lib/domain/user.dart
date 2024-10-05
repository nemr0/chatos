import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;

  const User({required this.id, required this.email, required this.name});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      email: doc['email'] ?? '',
      name: doc['name']??'',
    );
  }

  factory User.fromMap(Map<String, String> doc) {
    return User(
      id: doc['id'] ?? '',
      email: doc['email'] ?? '',
      name: doc['name']??'',
    );
  }

  Map<String, String> toMap() => {'id': id, 'name': name, 'email': email};

  @override
  List<Object?> get props => [id, email, name];

  @override
  String toString() =>'User(id:$id, email: $email, name: $name)';

}
