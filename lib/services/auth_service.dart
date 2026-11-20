// Auth Service - লগইন / Register / Lock
// পাসওয়ার্ড Hash, ৫ বার ভুল দিলে ১৫ মিনিট Lock, Logout না করা পর্যন্ত Login থাকবে, ডাটা ডিলিট হবে না।

import 'package:hive/hive.dart';

class AuthService {
  static const String _authBox = 'kormi_auth';
  static const String _usersBox = 'kormi_users';
  static const int _maxWrong = 5;
  static const int _lockMinutes = 15;

  // Simple Hash - আসল অ্যাপে sha256 ব্যবহার করবো, এখন লাইট Hash
  static String hashPassword(String pass) {
    int h = 0;
    for (int i = 0; i < pass.length; i++) {
      h = (h * 31 + pass.codeUnitAt(i)) & 0x7fffffff;
    }
    return h.toString();
  }

  // Admin ডিফল্ট: ADMIN / ADMIN123
  static Future<void> ensureAdmin() async {
    final box = await Hive.openBox(_usersBox);
    if (!box.containsKey('ADMIN')) {
      await box.put('ADMIN', {
        'username': 'ADMIN',
        'password': hashPassword('ADMIN123'),
        'role': 'Admin',
        'status': 'Active',
        'name': 'Admin',
      });
    }
  }

  // লগইন চেক
  // return: 'ok' / 'pending' / 'locked' / 'wrong' / 'notfound'
  static Future<Map<String, dynamic>> login(String username, String password) async {
    await ensureAdmin();
    final users = await Hive.openBox(_usersBox);
    final auth = await Hive.openBox(_authBox);

    // Lock চেক
    final lockUntil = auth.get('lock_${username}_until') as int?;
    if (lockUntil != null && DateTime.now().millisecondsSinceEpoch < lockUntil) {
      final remain = ((lockUntil - DateTime.now().millisecondsSinceEpoch) / 60000).ceil();
      return {'result': 'locked', 'remain': remain};
    }

    final user = users.get(username);
    if (user == null) {
      return {'result': 'notfound'};
    }

    if (user['status'] == 'Pending') {
      return {'result': 'pending'};
    }

    if (user['password'] != hashPassword(password)) {
      int wrong = (auth.get('wrong_$username') ?? 0) as int;
      wrong += 1;
      await auth.put('wrong_$username', wrong);
      if (wrong >= _maxWrong) {
        final until = DateTime.now().add(const Duration(minutes: _lockMinutes)).millisecondsSinceEpoch;
        await auth.put('lock_${username}_until', until);
        await auth.put('wrong_$username', 0);
        return {'result': 'locked', 'remain': _lockMinutes};
      }
      return {'result': 'wrong', 'left': _maxWrong - wrong};
    }

    // সফল
    await auth.put('wrong_$username', 0);
    await auth.delete('lock_${username}_until');
    await auth.put('current_user', username);
    await auth.put('current_role', user['role']);
    await auth.put('is_logged_in', true);
    return {'result': 'ok', 'role': user['role'], 'name': user['name']};
  }

  // Worker / Officer Register - Pending
  static Future<bool> register({
    required String username,
    required String password,
    required String name,
    required String role,
    required String card,
  }) async {
    final users = await Hive.openBox(_usersBox);
    if (users.containsKey(username)) return false;
    await users.put(username, {
      'username': username,
      'password': hashPassword(password),
      'role': role,
      'status': 'Pending',
      'name': name,
      'card': card,
    });
    return true;
  }

  // Admin Approve
  static Future<void> approveUser(String username) async {
    final users = await Hive.openBox(_usersBox);
    final u = users.get(username);
    if (u != null) {
      u['status'] = 'Active';
      await users.put(username, u);
    }
  }

  static Future<void> logout() async {
    final auth = await Hive.openBox(_authBox);
    // ডাটা ডিলিট করবো না, শুধু Lock করবো
    await auth.put('is_logged_in', false);
    await auth.delete('current_user');
    await auth.delete('current_role');
  }

  static Future<bool> isLoggedIn() async {
    final auth = await Hive.openBox(_authBox);
    return (auth.get('is_logged_in') ?? false) as bool;
  }

  static Future<String?> currentUser() async {
    final auth = await Hive.openBox(_authBox);
    return auth.get('current_user') as String?;
  }

  static Future<String?> currentRole() async {
    final auth = await Hive.openBox(_authBox);
    return auth.get('current_role') as String?;
  }
}
