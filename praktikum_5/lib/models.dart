import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF3949AB);

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map['id'], name: map['name'], email: map['email']);
  }
}

class TransactionItem {
  final int? id;
  final int userId;
  final String title;
  final int amount;
  final String category;
  final String date;

  TransactionItem({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  bool get isIncome => category == 'Pemasukan';

  String get amountText => '${isIncome ? '+' : '-'} ${formatRupiah(amount)}';

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
    );
  }
}

class Session {
  static User? currentUser;
}

String formatRupiah(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${value < 0 ? '- ' : ''}Rp $buffer';
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Makanan':
      return Icons.fastfood;
    case 'Transportasi':
      return Icons.directions_car;
    case 'Hiburan':
      return Icons.movie;
    case 'Pemasukan':
      return Icons.attach_money;
    default:
      return Icons.receipt;
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'Makanan':
      return Colors.orange;
    case 'Transportasi':
      return Colors.blueAccent;
    case 'Hiburan':
      return Colors.purple;
    case 'Pemasukan':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
