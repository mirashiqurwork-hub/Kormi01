class WorkerModel {
  final String cardNumber;
  final String fullName;
  final String nid;
  final String phone;
  final String dob;
  final String joiningDate;
  final String salary;
  final String company;
  final String role;
  final String shift;
  final String status;

  WorkerModel({
    required this.cardNumber,
    required this.fullName,
    required this.nid,
    required this.phone,
    required this.dob,
    required this.joiningDate,
    required this.salary,
    required this.company,
    required this.role,
    required this.shift,
    this.status = 'Active',
  });

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      cardNumber: (map['cardNumber'] ?? '').toString(),
      fullName: (map['fullName'] ?? map['name'] ?? '').toString(),
      nid: (map['nid'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      dob: (map['dob'] ?? '').toString(),
      joiningDate: (map['joiningDate'] ?? '').toString(),
      salary: (map['salary'] ?? '').toString(),
      company: (map['company'] ?? '').toString(),
      role: (map['role'] ?? 'Worker').toString(),
      shift: (map['shift'] ?? 'General').toString(),
      status: (map['status'] ?? 'Active').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'fullName': fullName,
      'nid': nid,
      'phone': phone,
      'dob': dob,
      'joiningDate': joiningDate,
      'salary': salary,
      'company': company,
      'role': role,
      'shift': shift,
      'status': status,
    };
  }
}
