class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String city;
  final String postcode;
  final String country;
  final String userDisplayName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.postcode,
    required this.country,
    required this.userDisplayName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '0', // Default to '0' if id is null
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      phoneNumber: json['billing']?['phone'] ?? '',
      address: json['billing']?['address_1'] ?? '',
      city: json['billing']?['city'] ?? '',
      postcode: json['billing']?['postcode'] ?? '',
      country: json['billing']?['country'] ?? '',
      userDisplayName: json['username'] ?? '',
    );
  }
}
