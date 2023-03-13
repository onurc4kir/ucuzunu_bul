class User {
  User({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? city;
  String? country;
  String? postalCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
        address: json["address"],
        city: json["city"],
        country: json["country"],
        postalCode: json["postalCode"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "address": address,
        "city": city,
        "country": country,
        "postalCode": postalCode,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
