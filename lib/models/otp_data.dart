class OTPData {
  String emailOTP = '';
  String smsOTP = '';

  OTPData.fromJson(Map<String, dynamic> json) {
    if (json['sms_otp'] != null) {
      emailOTP = json['email_otp'].toString();
      smsOTP = json['sms_otp'].toString();
    }
  }
}
