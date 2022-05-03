// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChurchModel {
  String? id;
  final String churchName;
  final String phoneNumber;
  final String email;
  final Map<String, dynamic> leaderInfo;
  final List<dynamic> serviceTime; //TODO: change type notation
  final String street;
  final String address;
  final String streetNumber;
  final String city;
  final String postCode;
  final Map<String, dynamic>? latLong;
  String? imageURL;
  final String province;

  ChurchModel({
    this.id,
    required this.churchName,
    required this.phoneNumber,
    required this.email,
    required this.leaderInfo,
    required this.serviceTime,
    required this.street,
    required this.address,
    required this.streetNumber,
    required this.city,
    required this.postCode,
    this.latLong,
    this.imageURL,
    required this.province,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'churchName': churchName,
      'phoneNumber': phoneNumber,
      'email': email,
      'leaderInfo': leaderInfo,
      'serviceTime': serviceTime,
      'street': street,
      'streetNumber': streetNumber,
      'city': city,
      'postCode': postCode,
      'latLong': latLong,
      'imageURL': imageURL,
      'province': province,
    };
  }

  factory ChurchModel.fromMap({required Map<String, dynamic> map}) {
    return ChurchModel(
      id: map['id'] ?? '',
      churchName: map['churchName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      leaderInfo: map['leaderInfo'] ?? {},
      serviceTime: map['serviceTime'] ?? [],
      street: map['street'] ?? '',
      streetNumber: map['streetNumber'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      postCode: map['postCode'] ?? '',
      latLong: map['latLong'],
      imageURL: map['imageURL'] ?? '',
      province: map['province'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ChurchModel(id: $id, churchName: $churchName, phoneNumber: $phoneNumber, email: $email, leaderInfo: $leaderInfo, serviceTime: $serviceTime, street: $street, address: $address, streetNumber: $streetNumber, city: $city, postCode: $postCode, latLong: $latLong, imageURL: $imageURL, province: $province)';
  }
}
