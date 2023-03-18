class User {
  String id;
  String? name;
  String? mail;
  String? imageUrl;
  String? phone;
  int? point;
  String? role;

  User({
    required this.id,
    this.name,
    this.mail,
    this.imageUrl,
    this.phone,
    this.point,
    this.role,
  });

  // generate from map method
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      mail: map['mail'],
      imageUrl: map['image_url'],
      phone: map['phone'],
      point: map['point'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'mail': mail,
        'image_url': imageUrl,
        'phone': phone,
        'point': point,
        'role': role,
      };

  //copyWith method
  User copyWith({
    String? id,
    String? name,
    String? mail,
    String? imageUrl,
    String? phone,
    int? point,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      mail: mail ?? this.mail,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      point: point ?? this.point,
      role: role ?? this.role,
    );
  }
}
