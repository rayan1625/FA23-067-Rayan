import 'package:flutter/material.dart';
import '../models/patient.dart';
import 'patient_detail_screen.dart';

class AllPatientsScreen extends StatelessWidget {
  final List<Patient> patients;
  const AllPatientsScreen({super.key, required this.patients});

  void _showPatientMenu(BuildContext context, Patient patient) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility, color: Colors.blue),
            title: const Text('View'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailScreen(patient: patient),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.orange),
            title: const Text('Edit'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _showDeleteDialog(context, patient);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('All Patients (${patients.length})'),
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
        body: patients.isEmpty
            ? const Center(child: Text('No patients yet'))
            : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                    child: Text(
                      patient.name[0].toUpperCase(),
                      style: const TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${patient.age} years • ${patient.phone}'),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'view') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientDetailScreen(patient: patient),
                          ),
                        );
                      } else {
                        _showPatientMenu(context, patient);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility), SizedBox(width: 10), Text('View')])),
                      const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 10), Text('Edit')])),
                      const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 10), Text('Delete', style: TextStyle(color: Colors.red))])),
                    ],
                  ),
                ),
              );
            },
            ),
        );
    }
}
