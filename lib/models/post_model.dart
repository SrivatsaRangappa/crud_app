class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    this.id = 0, // Default value for id
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'] ?? 0, // Default to 0 if id is null
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
