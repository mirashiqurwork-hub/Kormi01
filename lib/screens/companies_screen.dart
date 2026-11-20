// Companies Screen - কোম্পানি
// শুধু তুমি (Admin) কোম্পানি যোগ / বাদ / নাম বদলাতে পারবা। অন্য কেউ পারবে না।

import 'package:flutter/material.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  List<Map<String, String>> _companies = [
    {'name': 'Company 1', 'nightBill': '150', 'units': '2'},
    {'name': 'Company 2', 'nightBill': '180', 'units': '1'},
  ];

  final _nameController = TextEditingController();
  final _billController = TextEditingController();

  void _addCompany() {
    if (_nameController.text.trim().isEmpty) return;
    setState(() {
      _companies.add({
        'name': _nameController.text.trim(),
        'nightBill': _billController.text.trim().isEmpty ? '0' : _billController.text.trim(),
        'units': '1',
      });
      _nameController.clear();
      _billController.clear();
    });
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নতুন কোম্পানি'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'কোম্পানির নাম'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Night Bill রেট (টাকা)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
            onPressed: _addCompany,
            child: const Text('যোগ করুন', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D3F),
        title: const Text(
          'কোম্পানি',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _companies.length,
        itemBuilder: (context, index) {
          final c = _companies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFD4AF37),
                child: Icon(Icons.business, color: Colors.black),
              ),
              title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Night Bill: ${c['nightBill']} টাকা | Unit: ${c['units']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Color(0xFFD4AF37)), onPressed: () {}),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _companies.removeAt(index)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
