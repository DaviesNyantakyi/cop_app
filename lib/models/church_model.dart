// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class ChurchModel {
  String? id;
  final String churchName;
  final Map<String, dynamic> leaderInfo;
  final Map<String, dynamic> contactInfo;
  final String street;
  final String address;
  final String streetNumber;
  final String city;
  final String postcode;
  final Map<String, dynamic>? latLong;
  String? imageURL;
  final String province;

  ChurchModel({
    this.id,
    required this.churchName,
    required this.leaderInfo,
    required this.contactInfo,
    required this.street,
    required this.address,
    required this.streetNumber,
    required this.city,
    required this.postcode,
    this.latLong,
    this.imageURL,
    required this.province,
  });

  ChurchModel copyWith({
    String? id,
    String? churchName,
    Map<String, dynamic>? leaderInfo,
    Map<String, dynamic>? contactInfo,
    String? street,
    String? address,
    String? streetNumber,
    String? city,
    String? postcode,
    Map<String, dynamic>? latLong,
    String? imageURL,
    String? province,
  }) {
    return ChurchModel(
      id: id ?? this.id,
      churchName: churchName ?? this.churchName,
      leaderInfo: leaderInfo ?? this.leaderInfo,
      contactInfo: contactInfo ?? this.contactInfo,
      street: street ?? this.street,
      address: address ?? this.address,
      streetNumber: streetNumber ?? this.streetNumber,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      latLong: latLong ?? this.latLong,
      imageURL: imageURL ?? this.imageURL,
      province: province ?? this.province,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'churchName': churchName,
      'leaderInfo': leaderInfo,
      'contactInfo': contactInfo,
      'street': street,
      'address': address,
      'streetNumber': streetNumber,
      'city': city,
      'postcode': postcode,
      'latLong': latLong,
      'imageURL': imageURL,
      'province': province,
    };
  }

  factory ChurchModel.fromMap({required Map<String, dynamic> map}) {
    return ChurchModel(
      id: map['id'] ?? '',
      churchName: map['churchName'] ?? '',
      contactInfo: map['contactInfo'] ?? {},
      leaderInfo: map['leaderInfo'] ?? {},
      street: map['street'] ?? '',
      address: map['address'] ?? '',
      streetNumber: map['streetNumber'] ?? '',
      city: map['city'] ?? '',
      postcode: map['postcode'] ?? '',
      latLong: map['latLong'] ?? {},
      imageURL: map['imageURL'] ?? '',
      province: map['province'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ChurchModel(id: $id, churchName: $churchName, leaderInfo: $leaderInfo, contactInfo: $contactInfo, street: $street, address: $address, streetNumber: $streetNumber, city: $city, postcode: $postcode, latLong: $latLong, imageURL: $imageURL, province: $province)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChurchModel &&
        other.id == id &&
        other.churchName == churchName &&
        mapEquals(other.leaderInfo, leaderInfo) &&
        mapEquals(other.contactInfo, contactInfo) &&
        other.street == street &&
        other.address == address &&
        other.streetNumber == streetNumber &&
        other.city == city &&
        other.postcode == postcode &&
        mapEquals(other.latLong, latLong) &&
        other.imageURL == imageURL &&
        other.province == province;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        churchName.hashCode ^
        leaderInfo.hashCode ^
        contactInfo.hashCode ^
        street.hashCode ^
        address.hashCode ^
        streetNumber.hashCode ^
        city.hashCode ^
        postcode.hashCode ^
        latLong.hashCode ^
        imageURL.hashCode ^
        province.hashCode;
  }
}
