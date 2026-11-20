// KORMI - Register Screen - FINAL
// Photo Mandatory + Card / Password / Company Mandatory
// Role অনুযায়ী Designation / Section / Unit / Shift বদলাবে
// Worker / Officer = Pending, Management / Admin = শুধু Admin বানাবে

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameC = TextEditingController();
  final _cardC = TextEditingController();
  final _nidC = TextEditingController();
  final _salaryC = TextEditingController();
  final _passC = TextEditingController();

  String _role = 'Worker';
  String _designation = 'HELPER';
  String _shift = 'P/B';
  String _section = 'RING';
  String _unit = 'UNIT-01';
  String _company = 'Kumira Spinning Mill';
  String _offDay = 'Friday';
  String _dob = '01.01.2000';
  String _joining = '18.11.2026';
  bool _hasPhoto = false;
  bool _showPass = false;

  final Map<String, List<String>> _designations = {
    'Worker': ['L/R', 'HELPER', 'SR.HELPER', 'JR.A.OP', 'SR.A.OP', 'OP', 'LINE-MAN'],
    'Officer': ['Supervisor', 'APO', 'SR APO', 'PO', 'SPO'],
    'Management': ['APM', 'DPM', 'PM', 'AGM', 'DGM', 'GM'],
    'Admin': ['Admin', 'Super Admin'],
  };

  @override
  void dispose() {
    _nameC.dispose();
    _cardC.dispose();
    _nidC.dispose();
    _salaryC.dispose();
    _passC.dispose();
    super.dispose();
  }

  List<String> get _sections {
    if (_role == 'Officer') return ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING', 'ALL SECTION'];
    return ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'];
  }

  List<String> get _units {
    if (_role == 'Management' || _role == 'Admin') return ['UNIT-01', 'UNIT-02', 'G/F', 'F/F', 'ALL UNIT'];
    return ['UNIT-01', 'UNIT-02', 'G/F', 'F/F'];
  }

  void _pickPhoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text('Photo Upload', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: KormiColors.navy)),
            const SizedBox(height: 8),
            ListTile(leading: const Icon(Icons.camera_alt_outlined, color: KormiColors.navy), title: const Text('Take Photo'), onTap: () { Navigator.pop(context); setState(() => _hasPhoto = true); }),
            ListTile(leading: const Icon(Icons.photo_library_outlined, color: KormiColors.navy), title: const Text('Choose from Gallery'), onTap: () { Navigator.pop(context); setState(() => _hasPhoto = true); }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _register() {
    if (!_hasPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo দেওয়া বাধ্যতামূলক - Photo তুলুন')));
      return;
    }
    if (_nameC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Full Name লিখুন')));
      return;
    }
    if (_cardC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card Number / Email লিখুন - এটাই Login ID হবে')));
      return;
    }
    if (_passC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password লিখুন')));
      return;
    }
    if (_passC.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password কমপক্ষে 6 অক্ষর হতে হবে')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registration Submitted'),
        content: Text(_role == 'Worker' || _role == 'Officer'
            ? '${_nameC.text} - Pending Approval\nAdmin Approve করলে Login করতে পারবেন।'
            : '${_nameC.text} - $_role Account শুধু Admin বানাতে পারবে। Request Admin এর কাছে গেছে।'),
        actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Photo - Mandatory
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: _hasPhoto ? KormiColors.green : KormiColors.red, width: 2)),
                child: _hasPhoto
                    ? const Icon(Icons.check_circle_outline, color: KormiColors.green, size: 40)
                    : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt_outlined, color: KormiColors.navy, size: 28), Text('Photo *', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12))]),
              ),
            ),
            const SizedBox(height: 6),
            Text(_hasPhoto ? 'Photo Uploaded ✓' : 'Photo বাধ্যতামূলক - চাপ দিয়ে Photo তুলুন', style: TextStyle(color: _hasPhoto ? KormiColors.green : KormiColors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),

            KormiCard(
              child: Column(
                children: [
                  _field('Full Name *', _nameC, 'e.g. Rahim Uddin'),
                  const SizedBox(height: 10),
                  _field('Card Number / Email * (Login ID)', _cardC, 'e.g. K-1050 / email'),
                  const SizedBox(height: 10),
                  _field('NID / Birth Certificate', _nidC, 'NID Number'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _dropdownBox('Role *', _role, ['Worker', 'Officer', 'Management', 'Admin'], (v) { setState(() { _role = v!; _designation = _designations[_role]!.first; if (!_sections.contains(_section)) _section = _sections.first; if (!_units.contains(_unit)) _unit = _units.first; }); })),
                      const SizedBox(width: 10),
                      Expanded(child: _dropdownBox('Designation', _designation, _designations[_role]!, (v) => setState(() => _designation = v!))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _dropdownBox('Shift', _shift, ['P/A', 'P/B', 'P/C'], (v) => setState(() => _shift = v!))),
                      const SizedBox(width: 10),
                      Expanded(child: _dropdownBox('Section', _section, _sections, (v) => setState(() => _section = v!))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _dropdownBox('Unit', _unit, _units, (v) => setState(() => _unit = v!))),
                      const SizedBox(width: 10),
                      Expanded(child: _dropdownBox('Weekly Off Day', _offDay, ['Friday', 'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'], (v) => setState(() => _offDay = v!))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _dropdownBox('Company *', _company, ['Kumira Spinning Mill', 'Unit 2'], (v) => setState(() => _company = v!))),
                      const SizedBox(width: 10),
                      Expanded(child: _field('Salary', _salaryC, 'e.g. 14500', isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _dateBox('DOB', _dob, () => setState(() => _dob = '01.01.2000'))),
                      const SizedBox(width: 10),
                      Expanded(child: _dateBox('Joining Date', _joining, () => setState(() => _joining = '18.11.2026'))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Password *', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passC,
                        obscureText: !_showPass,
                        decoration: InputDecoration(
                          hintText: 'Password (min 6)',
                          prefixIcon: const Icon(Icons.lock_outline, color: KormiColors.textGrey, size: 20),
                          suffixIcon: IconButton(icon: Icon(_showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20), onPressed: () => setState(() => _showPass = !_showPass)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            KormiPrimaryButton(label: 'Register - Submit for Approval', onPressed: _register),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Account আছে? ', style: TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Login করুন', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13))),
              ],
            ),
            const SizedBox(height: 8),
            const Text('* চিহ্নিত Field বাধ্যতামূলক। Photo ছাড়া Register হবে না।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(controller: controller, keyboardType: isNumber ? TextInputType.number : TextInputType.text, decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)))),
      ],
    );
  }

  Widget _dropdownBox(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(), onChanged: onChanged)),
        ),
      ],
    );
  }

  Widget _dateBox(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)), child: Row(children: [Expanded(child: Text(value, style: const TextStyle(fontSize: 13))), const Icon(Icons.calendar_today_outlined, size: 16, color: KormiColors.textGrey)])),
        ),
      ],
    );
  }
}
