import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/patient.dart';
import 'add_patient_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  const DashboardScreen({super.key, this.onThemeToggle});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final dbHelper = DatabaseHelper();
  List<Patient> patients = [];
  int patientCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final patients = await dbHelper.getAllPatients();
    setState(() {
      this.patients = patients;
      patientCount = patients.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dr. Assistant'),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) => _loadPatients()),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Stats Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('$patientCount', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const Text('Patients'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add Patient Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddPatientScreen()),
                  ).then((_) => _loadPatients());
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add New Patient'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPatientScreen()),
              ).then((_) => _loadPatients());
            },
            child: const Icon(Icons.add),
            ),
        );
    }
}
