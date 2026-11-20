// KORMI - Register / Create New Account - File 5
// রোল অনুযায়ী ডাইনামিক ফিল্ড বদলাবে
// Worker / Officer নিজে রেজিস্টার করতে পারবে - Status Pending
// Management / Admin নিজে রেজিস্টার করতে পারবে না - শুধু Admin বানিয়ে দিবে

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ---- সাধারণ ফিল্ড ----
  bool _hasPhoto = false;
  final _cardController = TextEditingController();
  final _nameController = TextEditingController();
  final _nidController = TextEditingController();
  final _salaryController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _dob;
  DateTime? _joiningDate;
  bool _hidePass = true;

  // ---- ড্রপডাউন ----
  String? _company;
  String _role = 'Worker';
  String? _designation;
  String? _shift;
  String? _section;
  String? _unit;
  String? _offDay;

  // কোম্পানি লিস্ট - পরে Admin Mills থেকে আসবে
  final List<String> _companies = [
    'KORMI Spinning Mills Ltd. - KSM-01',
    'Padma Spinning Unit-2 - KSM-02',
  ];

  final List<String> _roles = ['Worker', 'Officer', 'Management', 'Admin'];

  final List<String> _offDays = [
    'শুক্রবার',
    'শনিবার',
    'রবিবার',
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
  ];

  final List<String> _unitsWorkerOfficer = ['UNIT-01', 'UNIT-02', 'G/F', 'F/F'];
  final List<String> _unitsMgmtAdmin = ['ALL UNIT', 'UNIT-01', 'UNIT-02', 'G/F', 'F/F'];

  @override
  void dispose() {
    _cardController.dispose();
    _nameController.dispose();
    _nidController.dispose();
    _salaryController.dispose();
    _passController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // রোল বদলালে নিচের ফিল্ড রিসেট
  void _onRoleChanged(String? v) {
    if (v == null) return;
    setState(() {
      _role = v;
      _designation = null;
      _shift = null;
      _section = null;
      _unit = null;
      _offDay = null;
    });
  }

  // ডেট পিকার
  Future<void> _pickDate(bool isDob) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        if (isDob) {
          _dob = picked;
        } else {
          _joiningDate = picked;
        }
      });
    }
  }

  String _dateText(DateTime? d) {
    if (d == null) return 'Select Date';
    return '${d.day}/${d.month}/${d.year}';
  }

  // ডেজিগনেশন লিস্ট - রোল অনুযায়ী
  List<String> get _designationList {
    if (_role == 'Worker') {
      return ['L/R', 'HELPER', 'SR.HELPER', 'JR.A.OP', 'SR.A.OP', 'OP', 'LINE-MAN'];
    }
    if (_role == 'Officer') {
      return ['Supervisor', 'APO', 'SR APO', 'PO', 'SPO'];
    }
    if (_role == 'Management') {
      return ['APM', 'DPM', 'PM', 'AGM', 'DGM', 'GM'];
    }
    return ['Admin', 'Super Admin'];
  }

  String get _designationLabel {
    if (_role == 'Worker') return 'Worker Type (Designation)';
    if (_role == 'Officer') return 'Officer Type (Designation)';
    if (_role == 'Management') return 'Management Type';
    return 'Admin Type';
  }

  List<String> get _sectionList {
    if (_role == 'Officer') {
      return ['ALL SECTION', 'BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'];
    }
    return ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'];
  }

  // সেভ বাটন
  void _onSave() {
    // বাধ্যতামূলক ভ্যালিডেশন
    if (!_hasPhoto) {
      _showError('Profile Photo দিন (বাধ্যতামূলক)');
      return;
    }
    if (_cardController.text.trim().isEmpty) {
      _showError('Card Number / Email দিন (বাধ্যতামূলক)');
      return;
    }
    if (_passController.text.trim().isEmpty) {
      _showError('Password দিন (বাধ্যতামূলক)');
      return;
    }
    if (_company == null) {
      _showError('Company সিলেক্ট করুন (বাধ্যতামূলক)');
      return;
    }
    // Management / Admin নিজে রেজিস্টার করতে পারবে না
    if (_role == 'Management' || _role == 'Admin') {
      _showError('Management / Admin নিজে রেজিস্টার করতে পারবে না। Admin Add User থেকে বানিয়ে দিবে।');
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      _showError('Full Name দিন');
      return;
    }

    // সব ঠিক থাকলে সেভ - Status Pending
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account Saved - Status: Pending, Admin Approve করলে ঢুকতে পারবেন'),
      ),
    );
    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: KormiColors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMgmtAdmin = _role == 'Management' || _role == 'Admin';

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Create New Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- ১. Profile Photo ----
            Center(
              child: GestureDetector(
                onTap: () {
                  // পরে এখানে image_picker দিয়ে গ্যালারি খুলবে
                  setState(() => _hasPhoto = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo Selected (Gallery)')),
                  );
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: KormiColors.navy,
                      child: _hasPhoto
                          ? const Icon(Icons.person, size: 48, color: Colors.white)
                          : const Icon(Icons.camera_alt, size: 32, color: KormiColors.goldLight),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: KormiColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 16, color: KormiColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Profile Photo * (বাধ্যতামূলক)',
                style: TextStyle(color: KormiColors.textGrey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // ---- Role ----
            _label('Role'),
            _dropdown(_role, _roles, _onRoleChanged),
            const SizedBox(height: 12),

            // Management / Admin হলে সতর্কতা
            if (isMgmtAdmin)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: KormiColors.red.withOpacity(0.4)),
                ),
                child: const Text(
                  'Management / Admin নিজে রেজিস্টার করতে পারবে না। শুধু Admin Add User থেকে বানিয়ে দিবে।',
                  style: TextStyle(color: KormiColors.red, fontWeight: FontWeight.bold),
                ),
              ),
            if (isMgmtAdmin) const SizedBox(height: 12),

            // ---- সাধারণ ফিল্ড ----
            _label('Card Number / Email *'),
            _textField(_cardController, 'Card Number / Email', Icons.badge_outlined, TextInputType.emailAddress),
            const SizedBox(height: 12),

            _label('Full Name'),
            _textField(_nameController, 'Full Name', Icons.person_outline, TextInputType.name),
            const SizedBox(height: 12),

            _label('NID / Birth Certificate Number'),
            _textField(_nidController, 'NID / Birth Certificate', Icons.credit_card_outlined, TextInputType.number),
            const SizedBox(height: 12),

            // Date of Birth
            _label('Date of Birth'),
            _dateField(_dateText(_dob), () => _pickDate(true)),
            const SizedBox(height: 12),

            // Joining Date
            _label('Joining Date'),
            _dateField(_dateText(_joiningDate), () => _pickDate(false)),
            const SizedBox(height: 12),

            _label('Salary (Monthly)'),
            _textField(_salaryController, 'Salary', Icons.payments_outlined, TextInputType.number),
            const SizedBox(height: 12),

            // Password
            _label('Password *'),
            TextField(
              controller: _passController,
              obscureText: _hidePass,
              decoration: _inputStyle('Password', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility, color: KormiColors.textGrey),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Company
            _label('Company *'),
            _dropdown(_company, _companies, (v) => setState(() => _company = v), hint: 'Select Company'),
            const SizedBox(height: 16),

            // ---- ডাইনামিক ফিল্ড ----
            _label(_designationLabel),
            _dropdown(_designation, _designationList, (v) => setState(() => _designation = v), hint: 'Select $_designationLabel'),
            const SizedBox(height: 12),

            // Shift + Section - শুধু Worker / Officer এর জন্য
            if (!isMgmtAdmin) ...[
              _label('Shift'),
              _dropdown(_shift, ['P/A', 'P/B', 'P/C'], (v) => setState(() => _shift = v), hint: 'Select Shift'),
              const SizedBox(height: 12),
              _label('Section'),
              _dropdown(_section, _sectionList, (v) => setState(() => _section = v), hint: 'Select Section'),
              const SizedBox(height: 12),
            ],

            // Unit - Management / Admin হলে ALL UNIT সহ
            _label('Unit'),
            _dropdown(
              _unit,
              isMgmtAdmin ? _unitsMgmtAdmin : _unitsWorkerOfficer,
              (v) => setState(() => _unit = v),
              hint: 'Select Unit',
            ),
            const SizedBox(height: 12),

            // Weekly Off Day - শুধু Worker / Officer
            if (!isMgmtAdmin) ...[
              _label('Weekly Off Day'),
              _dropdown(_offDay, _offDays, (v) => setState(() => _offDay = v), hint: 'Select Off Day'),
              const SizedBox(height: 12),
            ],

            // Status - ডিফল্ট Pending
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address
            _label('Present Address'),
            _textField(_addressController, 'Present Address', Icons.location_on_outlined, TextInputType.streetAddress),
            const SizedBox(height: 20),

            // Save Button
            KormiPrimaryButton(
              label: 'Save Account',
              onPressed: _onSave,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ---- ছোট হেল্পার ----
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)),
    );
  }

  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: KormiColors.textGrey),
      prefixIcon: Icon(icon, color: KormiColors.textGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: KormiColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: KormiColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: KormiColors.navy, width: 1.5),
      ),
    );
  }

  Widget _textField(TextEditingController c, String hint, IconData icon, TextInputType type) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: _inputStyle(hint, icon),
    );
  }

  Widget _dateField(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KormiColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: KormiColors.textGrey),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(color: KormiColors.textDark))),
            const Icon(Icons.arrow_drop_down, color: KormiColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String? value, List<String> items, ValueChanged<String?> onChanged, {String? hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KormiColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint ?? 'Select', style: const TextStyle(color: KormiColors.textGrey)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
