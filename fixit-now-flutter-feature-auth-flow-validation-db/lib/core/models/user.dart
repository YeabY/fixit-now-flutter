enum Gender { MALE, FEMALE, OTHER }
enum Role { ADMIN, REQUESTER, PROVIDER }
enum ServiceType { CLEANING, PLUMBING, ELECTRICAL, CARPENTRY, PAINTING, GARDENING, MOVING, OTHER }

class User {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final Gender gender;
  final Role role;
  final String? password;
  final ServiceType? serviceType;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String? cbeAccount;
  final String? paypalAccount;
  final String? telebirrAccount;
  final String? awashAccount;
  final double? providerRating;
  final int? totalJobsCompleted;
  final double? totalIncome;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.role,
    this.password,
    this.serviceType,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.cbeAccount,
    this.paypalAccount,
    this.telebirrAccount,
    this.awashAccount,
    this.providerRating,
    this.totalJobsCompleted,
    this.totalIncome,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.toString() == 'Gender.${json['gender']}',
              orElse: () => Gender.OTHER)
          : Gender.OTHER,
      role: json['role'] != null
          ? Role.values.firstWhere(
              (e) => e.toString() == 'Role.${json['role']}',
              orElse: () => Role.REQUESTER)
          : Role.REQUESTER,
      serviceType: json['serviceType'] != null
          ? ServiceType.values.firstWhere(
              (e) => e.toString() == 'ServiceType.${json['serviceType']}',
              orElse: () => ServiceType.OTHER)
          : null,
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
      cbeAccount: json['cbeAccount'],
      paypalAccount: json['paypalAccount'],
      telebirrAccount: json['telebirrAccount'],
      awashAccount: json['awashAccount'],
      providerRating: json['providerRating']?.toDouble(),
      totalJobsCompleted: json['totalJobsCompleted'],
      totalIncome: json['totalIncome']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'gender': gender.toString().split('.').last,
      'role': role.toString().split('.').last,
      'password': password,
      'serviceType': serviceType?.toString().split('.').last,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'cbeAccount': cbeAccount,
      'paypalAccount': paypalAccount,
      'telebirrAccount': telebirrAccount,
      'awashAccount': awashAccount,
      'providerRating': providerRating,
      'totalJobsCompleted': totalJobsCompleted,
      'totalIncome': totalIncome,
    };
  }
}