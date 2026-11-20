// KORMI - Register Screen
// Photo Mandatory | Card Number/Email = Login ID
// Full Name, NID/Birth Certificate, DOB, Joining Date, Salary, Password
// Company Dropdown Mandatory | Role অনুযায়ী Dynamic Fields
// Worker / Officer Self-Register = Pending, Management / Admin শুধু Admin বানাবে

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _nidController = TextEditingController();
  final _salaryController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'Worker';
  String? _company;
  DateTime? _dob;
  DateTime? _joiningDate;
  bool _showPassword = false;
  bool _photoAdded = false;
  String _error = '';

  // Role অনুযায়ী Dynamic Fields
  final _sectionController = TextEditingController(text: 'Ring');
  final _shiftController = TextEditingController(text: 'P/B');
  final _designationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _nidController.dispose();
    _salaryController.dispose();
    _passwordController.dispose();
    _sectionController.dispose();
    _shiftController.dispose();
    _designationController.dispose();
    super.dispose();
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
            const Text('Photo তুলুন / সিলেক্ট করুন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: KormiColors.navy)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: KormiColors.navy),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _photoAdded = true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: KormiColors.navy),
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _photoAdded = true);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _save() {
    // Validation - Photo, Card, Password, Company Missing হলে Save হবে না
    if (!_photoAdded) {
      setState(() => _error = 'Photo Mandatory - Photo তুলুন');
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = 'Full Name দিন');
      return;
    }
    if (_cardController.text.trim().isEmpty) {
      setState(() => _error = 'Card Number / Email দিন - এটাই Login ID হবে');
      return;
    }
    if (_passwordController.text.trim().length < 4) {
      setState(() => _error = 'Password কমপক্ষে 4 অক্ষর হতে হবে');
      return;
    }
    if (_company == null) {
      setState(() => _error = 'Company সিলেক্ট করুন - Mandatory');
      return;
    }

    setState(() => _error = '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registration Successful'),
        content: Text(
          '$_role হিসেবে Register হয়েছে।\nStatus: Pending\nAdmin Approve করলে Login করতে পারবেন।\nCard: ${_cardController.text.trim()}',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: KormiColors.navy),
            child: const Text('Login এ যান', style: TextStyle(color: KormiColors.goldLight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Photo - Mandatory
            KormiCard(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _photoAdded ? KormiColors.navy : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: KormiColors.gold, width: 2),
                      ),
                      child: _photoAdded
                          ? const Icon(Icons.person_outlined, size: 50, color: KormiColors.goldLight)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined, color: KormiColors.navy, size: 28),
                                SizedBox(height: 4),
                                Text('Add Photo *', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_photoAdded ? 'Photo Added ✓' : 'Photo Mandatory - না দিলে Save হবে না',
                      style: TextStyle(
                          color: _photoAdded ? KormiColors.green : KormiColors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Role Selector
            KormiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Role সিলেক্ট করুন', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Worker', 'Officer', 'Management', 'Admin'].map((r) {
                      final active = _role == r;
                      final disabled = r == 'Management' || r == 'Admin';
                      return GestureDetector(
                        onTap: () {
                          if (disabled) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$r শুধু Admin বানাতে পারবে, Self-Register হবে না')),
                            );
                            return;
                          }
                          setState(() => _role = r);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: active ? KormiColors.navy : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: disabled ? KormiColors.border : KormiColors.navy.withOpacity(0.3)),
                          ),
                          child: Text(
                            disabled ? '$r (Admin Only)' : r,
                            style: TextStyle(
                              color: active ? KormiColors.goldLight : (disabled ? KormiColors.textGrey : KormiColors.navy),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Form
            KormiCard(
              child: Column(
                children: [
                  _field('Full Name *', _nameController, 'Full Name দিন', Icons.person_outlined),
                  const SizedBox(height: 12),
                  _field('Card Number / Email (Login ID) *', _cardController, 'যেমন K-1042 / email', Icons.badge_outlined),
                  const SizedBox(height: 12),
                  _field('NID / Birth Certificate', _nidController, 'NID / Birth Certificate No', Icons.credit_card_outlined),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _dateField('DOB', _dob, () async {
                        final p = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1970), lastDate: DateTime.now());
                        if (p != null) setState(() => _dob = p);
                      })),
                      const SizedBox(width: 10),
                      Expanded(child: _dateField('Joining Date', _joiningDate, () async {
                        final p = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                        if (p != null) setState(() => _joiningDate = p);
                      })),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _field('Salary', _salaryController, 'Salary (৳)', Icons.money_outlined, isNumber: true),
                  const SizedBox(height: 12),
                  // Company - Mandatory
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Company *', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: KormiColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _company,
                            hint: const Text('Company সিলেক্ট করুন - Mandatory'),
                            isExpanded: true,
                            items: ['Mill 1 - Kumira', 'Mill 2 - Sitakunda', 'Mill 3 - Bhatiary']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) => setState(() => _company = v),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Password *', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          hintText: 'Password দিন',
                          prefixIcon: const Icon(Icons.lock_outlined, color: KormiColors.navy),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: KormiColors.textGrey),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Role Dynamic Fields
                  if (_role == 'Worker') ...[
                    _field('Section', _sectionController, 'Ring / Carding / Packing', Icons.factory_outlined),
                    const SizedBox(height: 12),
                    _field('Shift', _shiftController, 'P/A / P/B / P/C', Icons.access_time_outlined),
                  ],
                  if (_role == 'Officer') ...[
                    _field('Designation', _designationController, 'যেমন Production Officer', Icons.work_outlined),
                    const SizedBox(height: 12),
                    _field('Section', _sectionController, 'Production / Quality', Icons.factory_outlined),
                  ],
                ],
              ),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: KormiColors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: Text(_error, style: const TextStyle(color: KormiColors.red, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
            const SizedBox(height: 14),
            KormiPrimaryButton(label: 'Register as Pending - Save', onPressed: _save),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have account? ', style: TextStyle(color: KormiColors.textGrey)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Login', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: KormiColors.navy, size: 20)),
        ),
      ],
    );
  }

  Widget _dateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KormiColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18, color: KormiColors.navy),
                const SizedBox(width: 8),
                Text(date == null ? 'Select Date' : '${date.day}/${date.month}/${date.year}',
                    style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
