// KORMI - Overtime Screen - REAL ACTION
// OT Hours থেকে OT Amount Real Calculation + Approve / Reject

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  String _filter = 'All';
  String _shift = 'P/B-R/C';

  // OT Calculator Inputs
  final _salaryController = TextEditingController(text: '14500');
  final _otHoursController = TextEditingController(text: '2');
  final _nightHoursController = TextEditingController(text: '0');

  final List<Map<String, dynamic>> _requests = [
    {'card': 'K-1042', 'name': 'Karim Sheikh', 'section': 'RING', 'date': '18.11.26', 'otHours': 2.0, 'nightHours': 0.0, 'salary': 14500.0, 'status': 'Pending', 'reason': 'Ring Frame Extra Production'},
    {'card': 'K-1045', 'name': 'Jashim Uddin', 'section': 'PACKING', 'date': '18.11.26', 'otHours': 3.0, 'nightHours': 1.0, 'salary': 13800.0, 'status': 'Approved', 'reason': 'Packing Backlog Clear'},
    {'card': 'K-1047', 'name': 'Abdul Kader', 'section': 'RING', 'date': '17.11.26', 'otHours': 1.5, 'nightHours': 0.0, 'salary': 15200.0, 'status': 'Pending', 'reason': 'Machine Breakdown Cover'},
    {'card': 'K-1046', 'name': 'Mizanur Rahman', 'section': 'AUTOCONE', 'date': '17.11.26', 'otHours': 2.0, 'nightHours': 2.0, 'salary': 11200.0, 'status': 'Rejected', 'reason': 'Autocone Night Shift'},
  ];

  @override
  void dispose() {
    _salaryController.dispose();
    _otHoursController.dispose();
    _nightHoursController.dispose();
    super.dispose();
  }

  // Formula: Hourly = Salary / 208 (26 days x 8 hrs)
  // OT Amount = Hourly x OT Hours x 1.5
  // Night Bill = Night Hours x 50 (Fixed Demo Rate)
  double _hourly(double salary) => salary / 208;
  double _otAmount(double salary, double otHours) => _hourly(salary) * otHours * 1.5;
  double _nightAmount(double nightHours) => nightHours * 50;
  double _totalAmount(double salary, double otHours, double nightHours) => _otAmount(salary, otHours) + _nightAmount(nightHours);

  double get _calcOt {
    final s = double.tryParse(_salaryController.text) ?? 0;
    final h = double.tryParse(_otHoursController.text) ?? 0;
    return _otAmount(s, h);
  }

  double get _calcNight {
    final n = double.tryParse(_nightHoursController.text) ?? 0;
    return _nightAmount(n);
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _requests;
    if (_filter == 'Pending') list = list.where((e) => e['status'] == 'Pending').toList();
    if (_filter == 'Approved') list = list.where((e) => e['status'] == 'Approved').toList();
    if (_filter == 'Rejected') list = list.where((e) => e['status'] == 'Rejected').toList();
    return list;
  }

  double get _totalPendingAmount {
    double total = 0;
    for (final r in _requests.where((e) => e['status'] == 'Pending')) {
      total += _totalAmount(r['salary'], r['otHours'], r['nightHours']);
    }
    return total;
  }

  double get _totalApprovedAmount {
    double total = 0;
    for (final r in _requests.where((e) => e['status'] == 'Approved')) {
      total += _totalAmount(r['salary'], r['otHours'], r['nightHours']);
    }
    return total;
  }

  void _changeStatus(int idx, String newStatus) {
    setState(() => _requests[idx]['status'] = newStatus);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_requests[idx]['name']} - $newStatus')));
  }

  void _showAddRequest() {
    final cardC = TextEditingController();
    final nameC = TextEditingController();
    final otC = TextEditingController(text: '2');
    final nightC = TextEditingController(text: '0');
    final salaryC = TextEditingController(text: '14500');
    String section = 'RING';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New OT Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: KormiColors.navy)),
                const SizedBox(height: 12),
                TextField(controller: cardC, decoration: _input('Card Number')),
                const SizedBox(height: 10),
                TextField(controller: nameC, decoration: _input('Worker Name')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _dropdown('Section', section, ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'], (v) => setSheet(() => section = v!))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: salaryC, keyboardType: TextInputType.number, decoration: _input('Salary'))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: otC, keyboardType: TextInputType.number, decoration: _input('OT Hours'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: nightC, keyboardType: TextInputType.number, decoration: _input('Night Hours'))),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(12)),
                  child: Text('OT Amount: ${_otAmount(double.tryParse(salaryC.text) ?? 0, double.tryParse(otC.text) ?? 0).toStringAsFixed(0)} ৳ + Night: ${_nightAmount(double.tryParse(nightC.text) ?? 0).toStringAsFixed(0)} ৳ = Total: ${_totalAmount(double.tryParse(salaryC.text) ?? 0, double.tryParse(otC.text) ?? 0, double.tryParse(nightC.text) ?? 0).toStringAsFixed(0)} ৳', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(height: 14),
                KormiPrimaryButton(
                  label: 'Submit OT Request',
                  onPressed: () {
                    if (cardC.text.trim().isEmpty || nameC.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card + Name লিখুন')));
                      return;
                    }
                    setState(() {
                      _requests.insert(0, {'card': cardC.text.trim(), 'name': nameC.text.trim(), 'section': section, 'date': '18.11.26', 'otHours': double.tryParse(otC.text) ?? 0, 'nightHours': double.tryParse(nightC.text) ?? 0, 'salary': double.tryParse(salaryC.text) ?? 0, 'status': 'Pending', 'reason': 'OT Request'});
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OT Request Submitted - Pending Approval')));
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
    final calcSalary = double.tryParse(_salaryController.text) ?? 0;
    final calcOtH = double.tryParse(_otHoursController.text) ?? 0;
    final calcNightH = double.tryParse(_nightHoursController.text) ?? 0;

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Overtime'),
        actions: [IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: _showAddRequest)],
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, onPressed: _showAddRequest, child: const Icon(Icons.add)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // OT Calculator - Real
            KormiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('OT Calculator - Real Formula', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Hourly = Salary / 208 • OT = Hourly x Hours x 1.5 • Night = Hours x 50৳', style: TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _calcField('Salary', _salaryController)),
                      const SizedBox(width: 10),
                      Expanded(child: _calcField('OT Hours', _otHoursController)),
                      const SizedBox(width: 10),
                      Expanded(child: _calcField('Night Hours', _nightHoursController)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Text('Hourly Rate: ${_hourly(calcSalary).toStringAsFixed(2)} ৳', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('OT: ${_calcOt.toStringAsFixed(0)} ৳  +  Night: ${_calcNight.toStringAsFixed(0)} ৳', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Total: ${(_calcOt + _calcNight).toStringAsFixed(0)} ৳', style: const TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _summaryBox('Pending OT', '${_totalPendingAmount.toStringAsFixed(0)} ৳', KormiColors.gold)),
                const SizedBox(width: 8),
                Expanded(child: _summaryBox('Approved OT', '${_totalApprovedAmount.toStringAsFixed(0)} ৳', KormiColors.green)),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pending', 'Approved', 'Rejected'].map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: active ? KormiColors.navy : Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: KormiColors.border)), child: Text(f, style: TextStyle(color: active ? KormiColors.goldLight : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12))),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            ..._filtered.map((r) {
              final idx = _requests.indexOf(r);
              final status = r['status'] as String;
              final total = _totalAmount(r['salary'], r['otHours'], r['nightHours']);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('${r['name']} • ${r['card']}', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15))),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: status == 'Approved' ? KormiColors.green.withOpacity(0.12) : status == 'Rejected' ? KormiColors.red.withOpacity(0.10) : KormiColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: status == 'Approved' ? KormiColors.green : status == 'Rejected' ? KormiColors.red : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 11))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${r['section']} • Date: ${r['date']} • Reason: ${r['reason']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text('Salary: ${(r['salary'] as double).toStringAsFixed(0)} ৳ • OT: ${r['otHours']}h • Night: ${r['nightHours']}h', style: const TextStyle(color: KormiColors.navy, fontSize: 13)),
                      Text('OT Amount: ${_otAmount(r['salary'], r['otHours']).toStringAsFixed(0)} ৳ + Night: ${_nightAmount(r['nightHours']).toStringAsFixed(0)} ৳ = Total: ${total.toStringAsFixed(0)} ৳', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                      if (status == 'Pending') ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: ElevatedButton(onPressed: () => _changeStatus(idx, 'Approved'), style: ElevatedButton.styleFrom(backgroundColor: KormiColors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
                            const SizedBox(width: 8),
                            Expanded(child: OutlinedButton(onPressed: () => _changeStatus(idx, 'Rejected'), style: OutlinedButton.styleFrom(side: const BorderSide(color: KormiColors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Reject', style: TextStyle(color: KormiColors.red, fontWeight: FontWeight.bold, fontSize: 13)))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            const Text('OT Approve হলে Salary এর সাথে যোগ হবে।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _summaryBox(String label, String value, Color color) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)), child: Column(children: [Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)), Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11))]));
  }

  Widget _calcField(String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 11)), const SizedBox(height: 6), TextField(controller: controller, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: _input(label))]);
  }

  InputDecoration _input(String hint) {
    return InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)));
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)), const SizedBox(height: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)))]);
  }
}
