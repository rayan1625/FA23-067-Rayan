import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/visit.dart';

class AddVisitScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  const AddVisitScreen({super.key, required this.patientId, required this.patientName});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Visit - ${widget.patientName}'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _symptomsController,
                decoration: const InputDecoration(
                  labelText: 'Symptoms',
                  prefixIcon: Icon(Icons.sick),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter symptoms' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis',
                  prefixIcon: Icon(Icons.medical_information),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter diagnosis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _treatmentController,
                decoration: const InputDecoration(
                  labelText: 'Treatment',
                  prefixIcon: Icon(Icons.medication),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVisit,
                child: const Text('Save Visit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveVisit() async {
    if (_formKey.currentState!.validate()) {
      final visit = Visit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: widget.patientId,
        patientName: widget.patientName,
        date: _selectedDate,
        symptoms: _symptomsController.text,
        diagnosis: _diagnosisController.text,
        treatment: _treatmentController.text,
        notes: _notesController.text,
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.insertVisit(visit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit saved successfully!')),
        );
        Navigator.pop(context);
    }
    }
    }
}
