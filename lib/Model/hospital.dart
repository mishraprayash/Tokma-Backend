// models/health_service.dart

class HealthService {
  final String id;
  final String name;
  final String email;
  final String contactNo;
  final String profileImg;
  final bool isApproved;
  final bool isAvailable;
  final String description;
  final String regionalLocation;

  HealthService({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.profileImg,
    required this.isApproved,
    required this.isAvailable,
    required this.description,
    required this.regionalLocation,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) {
    return HealthService(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contactNo: json['contactNo'],
      profileImg: json['profileImg'] ?? '',
      isApproved: json['isApproved'],
      isAvailable: json['isAvailable'],
      description: json['description'],
      regionalLocation: json['regionalLocation'],
    );
  }
}
