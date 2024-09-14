class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String email;
  final List<String> groupId;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.email,
    required this.groupId,
  });

  // Convert UserModel object to a map for Firestore or other storage
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'email': email,
      'groupId': groupId,
    };
  }

  // Factory constructor to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      email: map['email'] ?? '',
      groupId: map['groupId'] != null
          ? List<String>.from(map['groupId'])
          : <String>[],
    );
  }


}
