class Profiledetails {
  final String? id;
  final String? email;
  final String? mobileNumber;
  final List<String> interests;
  final List<String> languages;
  final String? status;
  final String? reviewStatus;
  final bool? isVerified;
  final bool? isActive;
  final List<dynamic> favourites;
  final String? kycStatus;
  final List<dynamic> followers;
  final List<dynamic> femalefollowing;
  final List<dynamic> malefollowing;
  final List<dynamic> malefollowers;
  final List<dynamic> earnings;
  final List<dynamic> blockList;
  final bool? beautyFilter;
  final bool? hideAge;
  final bool? onlineStatus;
  final int? walletBalance;
  final int? coinBalance;
  final int? balance;
  final String? referralCode;
  final bool? referralBonusAwarded;
  final bool? profileCompleted;
  final List<dynamic> referredBy;
  final List<String> hobbies;
  final List<String> sports;
  final List<String> film;
  final List<String> music;
  final List<String> travel;
  final String? searchPreferences;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final int? age;
  final String? bio;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? videoUrl;
  final List<dynamic> images;
  final String? height;
  final dynamic religion;

  const Profiledetails({
    this.id,
    this.email,
    this.mobileNumber,
    this.interests = const [],
    this.languages = const [],
    this.status,
    this.reviewStatus,
    this.isVerified,
    this.isActive,
    this.favourites = const [],
    this.kycStatus,
    this.followers = const [],
    this.femalefollowing = const [],
    this.malefollowing = const [],
    this.malefollowers = const [],
    this.earnings = const [],
    this.blockList = const [],
    this.beautyFilter,
    this.hideAge,
    this.onlineStatus,
    this.walletBalance,
    this.coinBalance,
    this.balance,
    this.referralCode,
    this.referralBonusAwarded,
    this.profileCompleted,
    this.referredBy = const [],
    this.hobbies = const [],
    this.sports = const [],
    this.film = const [],
    this.music = const [],
    this.travel = const [],
    this.searchPreferences,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.age,
    this.bio,
    this.gender,
    this.firstName,
    this.lastName,
    this.name,
    this.videoUrl,
    this.images = const [],
    this.height,
    this.religion,
  });

  factory Profiledetails.fromJson(Map<String, dynamic> json) {
    return Profiledetails(
      id: (json["_id"] ?? json["id"])?.toString(),
      email: json["email"]?.toString() ?? null,
      mobileNumber: json["mobileNumber"]?.toString(),
      interests: (json["interests"] is List)
          ? List<String>.from(
              (json["interests"] as List).map((e) => e.toString()),
            )
          : const [],
      languages: (json["languages"] is List)
          ? List<String>.from(
              (json["languages"] as List).map((e) => e.toString()),
            )
          : const [],
      status: json["status"]?.toString(),
      reviewStatus: json["reviewStatus"]?.toString(),
      isVerified: json["isVerified"] is bool
          ? json["isVerified"] as bool
          : null,
      isActive: json["isActive"] is bool ? json["isActive"] as bool : null,
      favourites: (json["favourites"] is List)
          ? List<dynamic>.from(json["favourites"])
          : const [],
      kycStatus: json["kycStatus"]?.toString(),
      followers: (json["followers"] is List)
          ? List<dynamic>.from(json["followers"])
          : const [],
      femalefollowing: (json["femalefollowing"] is List)
          ? List<dynamic>.from(json["femalefollowing"])
          : const [],
      malefollowing: (json["malefollowing"] is List)
          ? List<dynamic>.from(json["malefollowing"])
          : const [],
      malefollowers: (json["malefollowers"] is List)
          ? List<dynamic>.from(json["malefollowers"])
          : const [],
      earnings: (json["earnings"] is List)
          ? List<dynamic>.from(json["earnings"])
          : const [],
      blockList: (json["blockList"] is List)
          ? List<dynamic>.from(json["blockList"])
          : const [],
      beautyFilter: json["beautyFilter"] is bool
          ? json["beautyFilter"] as bool
          : null,
      hideAge: json["hideAge"] is bool ? json["hideAge"] as bool : null,
      onlineStatus: json["onlineStatus"] is bool
          ? json["onlineStatus"] as bool
          : null,
      walletBalance: json["walletBalance"] is int
          ? json["walletBalance"] as int
          : _tryParseInt(json["walletBalance"]),
      coinBalance: json["coinBalance"] is int
          ? json["coinBalance"] as int
          : _tryParseInt(json["coinBalance"]),
      balance: json["balance"] is int
          ? json["balance"] as int
          : _tryParseInt(json["balance"]),
      referralCode: json["referralCode"]?.toString(),
      referralBonusAwarded: json["referralBonusAwarded"] is bool
          ? json["referralBonusAwarded"] as bool
          : null,
      profileCompleted: json["profileCompleted"] is bool
          ? json["profileCompleted"] as bool
          : null,
      referredBy: (json["referredBy"] is List)
          ? List<dynamic>.from(json["referredBy"])
          : const [],
      hobbies: (json["hobbies"] is List)
          ? List<String>.from(
              (json["hobbies"] as List).map((e) => e.toString()),
            )
          : const [],
      sports: (json["sports"] is List)
          ? List<String>.from((json["sports"] as List).map((e) => e.toString()))
          : const [],
      film: (json["film"] is List)
          ? List<String>.from((json["film"] as List).map((e) => e.toString()))
          : const [],
      music: (json["music"] is List)
          ? List<String>.from((json["music"] as List).map((e) => e.toString()))
          : const [],
      travel: (json["travel"] is List)
          ? List<String>.from((json["travel"] as List).map((e) => e.toString()))
          : const [],
      searchPreferences: json["searchPreferences"]?.toString(),
      createdAt: _tryParseDate(json["createdAt"]),
      updatedAt: _tryParseDate(json["updatedAt"]),
      v: json["__v"] is int ? json["__v"] as int : _tryParseInt(json["__v"]),
      age: json["age"] is int ? json["age"] as int : _tryParseInt(json["age"]),
      bio: json["bio"]?.toString(),
      gender: json["gender"]?.toString(),
      firstName: json["firstName"]?.toString(),
      lastName: json["lastName"]?.toString(),
      name:
          json["name"]?.toString() ??
          "${json["firstName"] ?? ''} ${json["lastName"] ?? ''}".trim(),
      videoUrl: json["videoUrl"]?.toString(),
      images: (json["images"] is List)
          ? List<dynamic>.from(json["images"])
          : const [],
      height: json["height"]?.toString(),
      religion: json["religion"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "mobileNumber": mobileNumber,
      "interests": interests,
      "languages": languages,
      "status": status,
      "reviewStatus": reviewStatus,
      "isVerified": isVerified,
      "isActive": isActive,
      "favourites": favourites,
      "kycStatus": kycStatus,
      "followers": followers,
      "femalefollowing": femalefollowing,
      "malefollowing": malefollowing,
      "malefollowers": malefollowers,
      "earnings": earnings,
      "blockList": blockList,
      "beautyFilter": beautyFilter,
      "hideAge": hideAge,
      "onlineStatus": onlineStatus,
      "walletBalance": walletBalance,
      "coinBalance": coinBalance,
      "balance": balance,
      "referralCode": referralCode,
      "referralBonusAwarded": referralBonusAwarded,
      "profileCompleted": profileCompleted,
      "referredBy": referredBy,
      "hobbies": hobbies,
      "sports": sports,
      "film": film,
      "music": music,
      "travel": travel,
      "searchPreferences": searchPreferences,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
      "age": age,
      "bio": bio,
      "gender": gender,
      "firstName": firstName,
      "lastName": lastName,
      "name": name,
      "videoUrl": videoUrl,
      "images": images,
      "height": height,
      "religion": religion,
    };
  }

  static DateTime? _tryParseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static int? _tryParseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      final v = int.tryParse(value);
      return v;
    }
    return null;
  }
}
