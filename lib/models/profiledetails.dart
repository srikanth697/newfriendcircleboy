// // To parse this JSON data, do
// //
// //     final profiledetails = profiledetailsFromJson(jsonString);

// import 'dart:convert';

// Profiledetails profiledetailsFromJson(String str) =>
//     Profiledetails.fromJson(json.decode(str));

// String profiledetailsToJson(Profiledetails data) => json.encode(data.toJson());

// class Profiledetails {
//   bool success;
//   Data data;

//   Profiledetails({required this.success, required this.data});

//   factory Profiledetails.fromJson(Map<String, dynamic> json) => Profiledetails(
//     success: json["success"],
//     data: Data.fromJson(json["data"]),
//   );

//   Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
// }

// class Data {
//   String id;
//   String email;
//   String mobileNumber;
//   List<String> interests;
//   List<String> languages;
//   String status;
//   String reviewStatus;
//   bool isVerified;
//   List<dynamic> favourites;
//   String kycStatus;
//   List<dynamic> followers;
//   List<dynamic> femalefollowing;
//   List<dynamic> earnings;
//   List<dynamic> blockList;
//   bool beautyFilter;
//   bool hideAge;
//   bool onlineStatus;
//   int walletBalance;
//   int coinBalance;
//   String referralCode;
//   bool referralBonusAwarded;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   int age;
//   String bio;
//   String gender;
//   String name;
//   String videoUrl;

//   Data({
//     required this.id,
//     required this.email,
//     required this.mobileNumber,
//     required this.interests,
//     required this.languages,
//     required this.status,
//     required this.reviewStatus,
//     required this.isVerified,
//     required this.favourites,
//     required this.kycStatus,
//     required this.followers,
//     required this.femalefollowing,
//     required this.earnings,
//     required this.blockList,
//     required this.beautyFilter,
//     required this.hideAge,
//     required this.onlineStatus,
//     required this.walletBalance,
//     required this.coinBalance,
//     required this.referralCode,
//     required this.referralBonusAwarded,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.age,
//     required this.bio,
//     required this.gender,
//     required this.name,
//     required this.videoUrl,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["_id"],
//     email: json["email"],
//     mobileNumber: json["mobileNumber"],
//     interests: List<String>.from(json["interests"].map((x) => x)),
//     languages: List<String>.from(json["languages"].map((x) => x)),
//     status: json["status"],
//     reviewStatus: json["reviewStatus"],
//     isVerified: json["isVerified"],
//     favourites: List<dynamic>.from(json["favourites"].map((x) => x)),
//     kycStatus: json["kycStatus"],
//     followers: List<dynamic>.from(json["followers"].map((x) => x)),
//     femalefollowing: List<dynamic>.from(json["femalefollowing"].map((x) => x)),
//     earnings: List<dynamic>.from(json["earnings"].map((x) => x)),
//     blockList: List<dynamic>.from(json["blockList"].map((x) => x)),
//     beautyFilter: json["beautyFilter"],
//     hideAge: json["hideAge"],
//     onlineStatus: json["onlineStatus"],
//     walletBalance: json["walletBalance"],
//     coinBalance: json["coinBalance"],
//     referralCode: json["referralCode"],
//     referralBonusAwarded: json["referralBonusAwarded"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     age: json["age"],
//     bio: json["bio"],
//     gender: json["gender"],
//     name: json["name"],
//     videoUrl: json["videoUrl"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "email": email,
//     "mobileNumber": mobileNumber,
//     "interests": List<dynamic>.from(interests.map((x) => x)),
//     "languages": List<dynamic>.from(languages.map((x) => x)),
//     "status": status,
//     "reviewStatus": reviewStatus,
//     "isVerified": isVerified,
//     "favourites": List<dynamic>.from(favourites.map((x) => x)),
//     "kycStatus": kycStatus,
//     "followers": List<dynamic>.from(followers.map((x) => x)),
//     "femalefollowing": List<dynamic>.from(femalefollowing.map((x) => x)),
//     "earnings": List<dynamic>.from(earnings.map((x) => x)),
//     "blockList": List<dynamic>.from(blockList.map((x) => x)),
//     "beautyFilter": beautyFilter,
//     "hideAge": hideAge,
//     "onlineStatus": onlineStatus,
//     "walletBalance": walletBalance,
//     "coinBalance": coinBalance,
//     "referralCode": referralCode,
//     "referralBonusAwarded": referralBonusAwarded,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "age": age,
//     "bio": bio,
//     "gender": gender,
//     "name": name,
//     "videoUrl": videoUrl,
//   };
// }
