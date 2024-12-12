
class UserModel {
  final String? token;
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;

  UserModel({
    this.token,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
  });

  // تحويل النموذج من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String?,
      email: json['user'] != null ? json['user']['email'] as String? : null,
      username: json['user'] != null ? json['user']['username'] as String? : null,
      firstName: json['user'] != null ? json['user']['first_name'] as String? : null,
      lastName: json['user'] != null ? json['user']['last_name'] as String? : null,
    );
  }

    factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String?,
      email: null,
      username: null,
      firstName: null,
      lastName: null,

    );
  }
  // تحويل النموذج إلى JSON
  Map<String, dynamic> toJson() => {
        if (token != null) 'token': token,
        if (email != null)
          'user': {
            'email': email,
            if (username != null) 'username': username,
            if (firstName != null) 'first_name': firstName,
            if (lastName != null) 'last_name': lastName,
          },
      };
      Map<String, dynamic> toJsonUpdate() => {
       
            'username': username,
            if (firstName != null) 'first_name': firstName,
            if (lastName != null) 'last_name': lastName,
          };
}