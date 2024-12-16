class InquiryModel {
  final int inquiryId;
  final String organizationName;
  final String address;
  final String contact;
  final String email;
  final String nature;
  String? remarks;
  final String inquiryDateTime;

  InquiryModel({
    required this.inquiryId,
    required this.organizationName,
    required this.address,
    required this.contact,
    required this.email,
    required this.nature,
    this.remarks,
    required this.inquiryDateTime,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      inquiryId: json['inquiryId'] ?? 0,
      organizationName: json['organizationName'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      nature: json['nature'] ?? 0,
      remarks: json['remarks'],
      inquiryDateTime: json['inquiryDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inquiryId': inquiryId,
      'organizationName': organizationName,
      'address': address,
      'contact': contact,
      'email': email,
      'nature': nature,
      'remarks': remarks,
      'inquiryDateTime': inquiryDateTime,
    };
  }
}
