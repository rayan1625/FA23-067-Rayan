import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_patient_screen.dart';
import 'all_patients_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import '../models/patient.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  const DashboardScreen({super.key, this.onThemeToggle});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Patient> patients = [];
  int newPatientsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJson = prefs.getStringList('patients') ?? [];
    setState(() {
      patients = patientsJson.map((json) => Patient.fromJson(jsonDecode(json))).toList();
      newPatientsCount = patients.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dr. Assistant'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Morning!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    DateFormat('EEEE, MMMM d').format(DateTime.now()),
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Today's Overview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today\'s Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.people, color: Colors.green),
                        Text('$newPatientsCount', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                        const Text('New Patients', style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(Icons.add, 'New Patient', Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPatientScreen())).then((_) => _loadPatients());
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionCard(Icons.search, 'Search', Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                  }),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildActionCard(Icons.people, 'All Patients', Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllPatientsScreen(patients: patients)));
            }),

            const SizedBox(height: 20),

            // Recent Patients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Patients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Color(0xFF2196F3))),
              ],
            ),
            ...patients.take(2).map((patient) => _buildPatientCard(patient)),
            if (patients.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    const Icon(Icons.people, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text('No patients yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    Text('Add your first patient', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPatientScreen())).then((_) => _loadPatients()),
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
              child: Text(patient.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold)),
            ),
            title: Text(patient.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(patient.phone),
            trailing: const Icon(Icons.arrow_forward_ios),
            ),
        );
    }
}
