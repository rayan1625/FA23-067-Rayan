import 'package:flutter/material.dart';

class Visit {
  final String id;
  final String patientId;
  final String patientName;
  final DateTime date;
  final String symptoms;
  final String diagnosis;
  final String treatment;
  final String notes;

  Visit({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.notes,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      date: DateTime.parse(json['date']),
      symptoms: json['symptoms'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'notes': notes,
    };
    }
}
