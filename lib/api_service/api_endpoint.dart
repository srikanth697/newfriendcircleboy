class ApiEndPoints {
  static const String baseUrls = "https://friend-circle-nine.vercel.app";
  static const String signupMale = "/male-user/register";
  static const String verifyOtpMale = "/male-user/verify-otp";
  static const String loginMale = "/male-user/login";
  static const String loginotpMale = "/male-user/verify-login-otp";
  static const String profiledetailsMale = "/male-user/add-info";

  // Male follow/unfollow
  static const String maleFollow = "/male-user/follow";
  static const String maleUnfollow = "/male-user/unfollow";
  static const String maleFollowing = "/male-user/following";
  static const String maleFollowers = "/male-user/followers";

  // Male favourites
  static const String maleAddFavourite = "/male-user/favourites/add-favourites";
  static const String maleListFavourites = "/male-user/favourites/list-favourites";
  static const String maleRemoveFavourite = "/male-user/favourites/remove-favourites";

  static const String signup = "/female-user/register";
  static const String verifyOtp = "/female-user/verify-otp";
  static const String login = "/female-user/login";
  static const String loginotp = "/female-user/verify-login-otp";
  static const String profiledetails = "/female-user/add-info";
}
