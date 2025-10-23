import 'package:flutter/material.dart';
import '../models/patient.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'patient_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Patient> allPatients = [];
  List<Patient> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJson = prefs.getStringList('patients') ?? [];
    setState(() {
      allPatients = patientsJson.map((json) => Patient.fromJson(jsonDecode(json))).toList();
      filteredPatients = allPatients;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPatients = allPatients.where((patient) =>
      patient.name.toLowerCase().contains(query) ||
          patient.phone.contains(query)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF2196F3),
          elevation: 0,
          title: const Text(
            'Search Patients',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          filteredPatients = allPatients;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // Results
              Expanded(
                child: filteredPatients.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      Text(
                        _searchController.text.isEmpty
                            ? 'No patients yet'
                            : 'No patients found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                          child: Text(
                            patient.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          patient.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${patient.age} years • ${patient.phone}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientDetailScreen(patient: patient),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            ),
        );
    }
}
