import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedDate = DateTime.now().toIso8601String();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) => value!.isEmpty ? 'Enter phone' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Gender: '),
                  Radio<String>(
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) => setState(() => _selectedGender = value),
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) => setState(() => _selectedGender = value),
                  ),
                  const Text('Female'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePatient,
                child: const Text('Save Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      final patient = Patient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: '',
        dateOfBirth: _selectedDate,
        gender: _selectedGender!,
        address: _addressController.text,
        notes: '',
        imagePath: '',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.insertPatient(patient);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient saved!')),
        );
        Navigator.pop(context);
    }
    }
    }
}
