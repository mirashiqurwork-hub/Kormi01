// Permission Service - কে কী দেখতে পারবে
// Admin / Management = সব। Officer = শুধু নিজের Unit + Permanent Shift। Worker = শুধু নিজে।

class PermissionService {
  static bool canSeeAll(String role) {
    return role == 'Admin' || role == 'Management';
  }

  static bool canApprove(String role) {
    return role == 'Admin';
  }

  static bool canManageCompany(String role) {
    // কোম্পানি শুধু তুমি (Admin) বদলাতে পারবা
    return role == 'Admin';
  }

  static bool canEditBottomBar(String role) {
    return role == 'Admin';
  }

  static bool canViewWorker({
    required String myRole,
    required String myUnit,
    required String myShift,
    required String workerUnit,
    required String workerShift,
    required String myCard,
    required String workerCard,
  }) {
    if (canSeeAll(myRole)) return true;
    if (myRole == 'Worker') return myCard == workerCard;
    if (myRole == 'Officer') {
      // Officer: শুধু নিজের Unit + Permanent Shift
      return myUnit == workerUnit && myShift == workerShift;
    }
    return false;
  }

  static bool canAddToUnit({
    required String myRole,
    required String myUnit,
    required String myShift,
    required String targetUnit,
    required String targetShift,
  }) {
    if (canSeeAll(myRole)) return true;
    if (myRole == 'Officer') {
      return myUnit == targetUnit && myShift == targetShift;
    }
    return false;
  }

  static bool canSeeLocation({
    required String myRole,
    required String myCard,
    required String targetCard,
  }) {
    if (myRole == 'Worker') return myCard == targetCard;
    return true; // Admin / Management / Officer অন্যদের লোকেশন দেখতে পারবে
  }

  static bool canUseAskAI({
    required String myRole,
    required String myUnit,
    required String myShift,
    required String targetUnit,
    required String targetShift,
    required String myCard,
    required String targetCard,
  }) {
    // ASK AI ও একই Permission মানবে
    if (myRole == 'Worker') return myCard == targetCard;
    if (myRole == 'Officer') return myUnit == targetUnit && myShift == targetShift;
    return true;
  }
}
