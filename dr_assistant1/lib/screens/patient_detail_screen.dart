import '../database/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/visit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_visit_screen.dart';


class PatientDetailScreen extends StatefulWidget {
  final Patient patient;
  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  List<Visit> visits = [];

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    final dbHelper = DatabaseHelper();
    final visits = await dbHelper.getVisitsByPatient(widget.patient.id);
    setState(() {
      this.visits =visits;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF2196F3),
                    child: Text(
                      widget.patient.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patient.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${widget.patient.age} years • ${widget.patient.gender}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Personal Info
            _buildInfoCard('Personal Info', [
              _buildInfoRow(Icons.phone, 'Phone', widget.patient.phone),
              _buildInfoRow(Icons.email, 'Email', widget.patient.email.isEmpty ? 'Not provided' : widget.patient.email),
              _buildInfoRow(Icons.location_on, 'Address', widget.patient.address),
            ]),

            const SizedBox(height: 20),

            // Medical Notes
            _buildInfoCard('Medical Notes', [
              _buildInfoRow(Icons.notes, 'Notes', widget.patient.notes.isEmpty ? 'No notes' : widget.patient.notes),
            ]),

            const SizedBox(height: 20),

            // Add Visit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddVisitScreen(
                        patientId: widget.patient.id,
                        patientName: widget.patient.name,
                      ),
                    ),
                  ).then((_) => _loadVisits());
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Visit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Visit History
            _buildInfoCard('Visit History (${visits.length})', [
              if (visits.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No visits yet', style: TextStyle(color: Colors.grey)),
                )
              else
                ...visits.map((visit) => _buildVisitCard(visit)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2196F3)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitCard(Visit visit) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${visit.date.day}/${visit.date.month}/${visit.date.year}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text('Symptoms: ${visit.symptoms}', style: TextStyle(color: Colors.grey[600])),
              Text('Diagnosis: ${visit.diagnosis}', style: TextStyle(color: Colors.grey[600])),
              if (visit.treatment.isNotEmpty) Text('Treatment: ${visit.treatment}', style: TextStyle(color: Colors.grey[600])),
            ],
            ),
        );
    }
}
