import 'package:hive/hive.dart';

part 'bank_details.g.dart';

@HiveType(typeId: 11)
class BankDetails {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? fullName;
  @HiveField(2)
  String? swiftCode;
  @HiveField(3)
  String? currency;
  @HiveField(4)
  int? accountNumber;
  @HiveField(5)
  String? ibanNumber;
  @HiveField(6)
  String? documentType;
  @HiveField(7)
  String? expiryDate;
  @HiveField(8)
  String? documentImage;
  @HiveField(9)
  String? signatureImageUrl;
  @HiveField(10)
  int? subscriptionPrice;
  @HiveField(11)
  String? createdAt;
  @HiveField(12)
  String? updatedAt;
  @HiveField(13)
  int? userId;
  @HiveField(14)
  int? countryId;
  @HiveField(15)
  int? bankId;
  @HiveField(16)
  String? documentNumber;

  BankDetails(
      {this.id,
      this.fullName,
      this.swiftCode,
      this.currency,
      this.accountNumber,
      this.ibanNumber,
      this.documentType,
      this.expiryDate,
      this.documentImage,
      this.signatureImageUrl,
      this.subscriptionPrice,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.countryId,
      this.documentNumber});

  BankDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    fullName = json['full_name']?.toString();
    swiftCode = json['bank_swift_code']?.toString();
    currency = json['account_currency']?.toString();
    accountNumber = 0;
    ibanNumber = json['iban_number']?.toString();
    documentType = json['document_type']?.toString();
    expiryDate = json['expiry_date']?.toString();
    documentNumber = json['document_number']?.toString();
    documentImage = json['document_image']?.toString();
    signatureImageUrl = json['signature']?.toString();
    subscriptionPrice = json['subscription_price']?.toInt();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    userId = json['user_id']?.toInt();
    countryId = json['country_id']?.toInt();
  }
}
