class User {
  final String id;
  final String name;
  final String? avatar;
  final bool isOnline;


  const User({
    required this.id,
    required this.name,
    this.avatar,
    this.isOnline = false,
  });


  User copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isOnline,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
    );
  }


  @override
  String toString() {
    return 'User(id: $id, name: $name, isOnline: $isOnline)';
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }


  @override
  int get hashCode => id.hashCode;
}
