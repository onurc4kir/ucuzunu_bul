class SupportTicketModel {
  int? id;
  String? subject;
  String? title;
  String? message;
  bool? status;
  String? userId;
  DateTime? createdAt;

  SupportTicketModel({
    this.id,
    this.subject,
    this.title,
    this.message,
    this.status,
    this.userId,
    this.createdAt,
  });

  factory SupportTicketModel.fromMap(Map<String, dynamic> map) {
    return SupportTicketModel(
      id: map['id'],
      subject: map['subject'],
      title: map['title'],
      message: map['message'],
      status: map['status'],
      userId: map['user_id'],
      createdAt: DateTime.tryParse(map['created_at'] ?? ""),
    );
  }

  Map<String, dynamic> toMap() => {
        'subject': subject,
        'title': title,
        'message': message,
        'user_id': userId,
      };
}
