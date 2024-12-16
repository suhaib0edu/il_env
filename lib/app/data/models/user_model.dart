class UserModel {
  String? userId;
  String? invitationCode;
  String? invitedBy;
  int? invitationCount;
  bool? unlimitedAccess;

  UserModel({
    this.userId,
    this.invitationCode,
    this.invitedBy,
    this.invitationCount,
    this.unlimitedAccess,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        invitationCode = json['invitationCode'],
        invitedBy = json['invitedBy'],
        invitationCount = json['invitationCount'],
        unlimitedAccess = json['unlimitedAccess'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'invitationCode': invitationCode,
        'invitedBy': invitedBy,
        'invitationCount': invitationCount,
        'unlimitedAccess': unlimitedAccess,
      };

  static UserModel clearUser() => UserModel(
        userId: null,
        invitationCode: null,
        invitedBy: null,
        invitationCount: null,
        unlimitedAccess: null,
      );
}
