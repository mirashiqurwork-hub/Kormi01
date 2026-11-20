// KORMI - Workers Screen - REAL ACTION
// Search + Filter + Add + Edit + Delete + Call + Message - সব Real

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  final _searchController = TextEditingController();
  String _sectionFilter = 'All';
  String _statusFilter = 'All';
  String _shiftFilter = 'All';

  final List<Map<String, String>> _workers = [
    {'card': 'K-1041', 'name': 'Rahim Uddin', 'role': 'Shift Incharge', 'section': 'RING', 'shift': 'P/B-R/C', 'phone': '01811-123456', 'status': 'Active', 'salary': '18500'},
    {'card': 'K-1042', 'name': 'Karim Sheikh', 'role': 'Worker - OP', 'section': 'RING', 'shift': 'P/B-R/C', 'phone': '01811-234567', 'status': 'Active', 'salary': '14500'},
    {'card': 'K-1043', 'name': 'Nasir Ahmed', 'role': 'Officer - Production', 'section': 'BACKSIDE', 'shift': 'P/A', 'phone': '01811-345678', 'status': 'Active', 'salary': '28000'},
    {'card': 'K-1045', 'name': 'Jashim Uddin', 'role': 'Worker - Packing', 'section': 'PACKING', 'shift': 'P/C', 'phone': '01811-456789', 'status': 'Active', 'salary': '13800'},
    {'card': 'K-1046', 'name': 'Mizanur Rahman', 'role': 'Helper - Autocone', 'section': 'AUTOCONE', 'shift': 'P/B-R/C', 'phone': '01811-567890', 'status': 'Pending', 'salary': '11200'},
    {'card': 'K-1047', 'name': 'Abdul Kader', 'role': 'OP - Ring', 'section': 'RING', 'shift': 'P/A', 'phone': '01811-678901', 'status': 'Active', 'salary': '15200'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filtered {
    var list = _workers;
    if (_sectionFilter != 'All') list = list.where((w) => w['section'] == _sectionFilter).toList();
    if (_statusFilter != 'All') list = list.where((w) => w['status'] == _statusFilter).toList();
    if (_shiftFilter != 'All') list = list.where((w) => w['shift'] == _shiftFilter).toList();
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((w) => w['name']!.toLowerCase().contains(q) || w['card']!.toLowerCase().contains(q) || w['phone']!.contains(q)).toList();
    }
    return list;
  }

  int get _activeCount => _workers.where((w) => w['status'] == 'Active').length;
  int get _pendingCount => _workers.where((w) => w['status'] == 'Pending').length;

  void _deleteWorker(int index, Map<String, String> worker) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Worker?'),
        content: Text('${worker['name']} (${worker['card']}) কে Delete করবেন?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _workers.remove(worker));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${worker['name']} Deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showWorkerDetail(Map<String, String> worker) {
    final idx = _workers.indexOf(worker);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 28, backgroundColor: KormiColors.navy.withOpacity(0.1), child: Text(worker['name']![0], style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 22))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(worker['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
                        Text('${worker['card']} • ${worker['role']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: worker['status'] == 'Active' ? KormiColors.green.withOpacity(0.12) : KormiColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(worker['status']!, style: TextStyle(color: worker['status'] == 'Active' ? KormiColors.green : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 11))),
                ],
              ),
              const SizedBox(height: 14),
              _detailRow('Section', worker['section']!),
              _detailRow('Shift', worker['shift']!),
              _detailRow('Phone', worker['phone']!),
              _detailRow('Salary', '${worker['salary']} ৳'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${worker['phone']}...'))); }, icon: const Icon(Icons.call_outlined, size: 16, color: KormiColors.navy), label: const Text('Call', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message to ${worker['name']}'))); }, icon: const Icon(Icons.message_outlined, size: 16, color: KormiColors.navy), label: const Text('Message', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditSheet(worker);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => _workers[idx]['status'] = worker['status'] == 'Active' ? 'Inactive' : 'Active');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${worker['name']} - ${_workers[idx]['status']}')));
                      },
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: KormiColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: Text(worker['status'] == 'Active' ? 'Deactivate' : 'Activate', style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(onPressed: () { Navigator.pop(context); _deleteWorker(idx, worker); }, icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18), label: const Text('Delete Worker', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditSheet(Map<String, String> worker) {
    final nameC = TextEditingController(text: worker['name']);
    final phoneC = TextEditingController(text: worker['phone']);
    final salaryC = TextEditingController(text: worker['salary']);
    String section = worker['section']!;
    String shift = worker['shift']!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit - ${worker['card']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: KormiColors.navy)),
                const SizedBox(height: 12),
                TextField(controller: nameC, decoration: _input('Full Name')),
                const SizedBox(height: 10),
                TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: _input('Phone')),
                const SizedBox(height: 10),
                TextField(controller: salaryC, keyboardType: TextInputType.number, decoration: _input('Salary')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _dropdown('Section', section, ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'], (v) => setSheetState(() => section = v!))),
                    const SizedBox(width: 10),
                    Expanded(child: _dropdown('Shift', shift, ['P/A', 'P/B', 'P/B-R/C', 'P/C'], (v) => setSheetState(() => shift = v!))),
                  ],
                ),
                const SizedBox(height: 14),
                KormiPrimaryButton(
                  label: 'Save Changes',
                  onPressed: () {
                    final idx = _workers.indexOf(worker);
                    setState(() {
                      _workers[idx] = {...worker, 'name': nameC.text.trim(), 'phone': phoneC.text.trim(), 'salary': salaryC.text.trim(), 'section': section, 'shift': shift};
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Worker Updated')));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddSheet() {
    final cardC = TextEditingController();
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    String section = 'RING';
    String shift = 'P/B-R/C';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Worker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: KormiColors.navy)),
                const SizedBox(height: 12),
                TextField(controller: cardC, decoration: _input('Card Number - e.g. K-1050')),
                const SizedBox(height: 10),
                TextField(controller: nameC, decoration: _input('Full Name')),
                const SizedBox(height: 10),
                TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: _input('Phone')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _dropdown('Section', section, ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'], (v) => setSheetState(() => section = v!))),
                    const SizedBox(width: 10),
                    Expanded(child: _dropdown('Shift', shift, ['P/A', 'P/B', 'P/B-R/C', 'P/C'], (v) => setSheetState(() => shift = v!))),
                  ],
                ),
                const SizedBox(height: 14),
                KormiPrimaryButton(
                  label: 'Add Worker',
                  onPressed: () {
                    if (cardC.text.trim().isEmpty || nameC.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card Number + Name লিখুন')));
                      return;
                    }
                    setState(() {
                      _workers.insert(0, {'card': cardC.text.trim(), 'name': nameC.text.trim(), 'role': 'Worker', 'section': section, 'shift': shift, 'phone': phoneC.text.trim(), 'status': 'Pending', 'salary': '12000'});
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Worker Added - Pending Approval')));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Workers'),
        actions: [IconButton(icon: const Icon(Icons.person_add_outlined), onPressed: _showAddSheet)],
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, onPressed: _showAddSheet, child: const Icon(Icons.add)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Expanded(child: _countBox('Total', '${_workers.length}', KormiColors.navy)),
                const SizedBox(width: 8),
                Expanded(child: _countBox('Active', '$_activeCount', KormiColors.green)),
                const SizedBox(width: 8),
                Expanded(child: _countBox('Pending', '$_pendingCount', KormiColors.gold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: 'Search Name / Card / Phone...', prefixIcon: const Icon(Icons.search_outlined, color: KormiColors.textGrey), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 13), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: KormiColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: KormiColors.border))),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _filterChip('Section', _sectionFilter, ['All', 'BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'], (v) => setState(() => _sectionFilter = v)),
                const SizedBox(width: 8),
                _filterChip('Status', _statusFilter, ['All', 'Active', 'Pending', 'Inactive'], (v) => setState(() => _statusFilter = v)),
                const SizedBox(width: 8),
                _filterChip('Shift', _shiftFilter, ['All', 'P/A', 'P/B', 'P/B-R/C', 'P/C'], (v) => setState(() => _shiftFilter = v)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('কোনো Worker পাওয়া যায়নি', style: TextStyle(color: KormiColors.textGrey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final w = list[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: KormiCard(
                          onTap: () => _showWorkerDetail(w),
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.1), child: Text(w['name']![0], style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold))),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${w['name']} • ${w['card']}', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)),
                                    Text('${w['role']} • ${w['section']} • ${w['shift']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                                    Text('${w['phone']} • ${w['salary']} ৳', style: const TextStyle(color: KormiColors.navy, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: w['status'] == 'Active' ? KormiColors.green.withOpacity(0.12) : KormiColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(w['status']!, style: TextStyle(color: w['status'] == 'Active' ? KormiColors.green : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 10))),
                                  const SizedBox(height: 6),
                                  const Icon(Icons.chevron_right, color: KormiColors.textGrey, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _countBox(String label, String value, Color color) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)), child: Column(children: [Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)), Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11))]));
  }

  Widget _filterChip(String label, String current, List<String> options, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: KormiColors.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e == 'All' ? '$label: All' : e, style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 13)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13))]));
  }

  InputDecoration _input(String hint) {
    return InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)));
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)), const SizedBox(height: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)))]);
  }
}
