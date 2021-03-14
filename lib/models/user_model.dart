import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userAddress,
  });

  final int id;
  final String name;
  final String email;
  final String phone;
  final Address userAddress;

  User.fromMap(Map<String, dynamic> map)
      : id = (map['id'] as num).toInt(),
        name = map['name'] as String,
        email = map['email'] as String,
        phone = map['phone'] as String,
        userAddress = Address.fromMap(map['userAddress']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userAddress': userAddress.toMap(),
    };
  }

  @override
  String toString() {
    return 'User:\n\tId: $id\n\tName: $name\n\tEmail: $email\n\tPhone: $phone\n\tAddress: ${userAddress.toString()}';
  }

  @override
  List<Object> get props => [name, email, id, phone, userAddress];
}

class Address extends Equatable {
  const Address({
    required this.houseNo,
    required this.locality,
    required this.city,
    required this.state,
  });

  final String houseNo;
  final String locality;
  final String city;
  final String state;

  Address.fromMap(Map<String, dynamic> map)
      : houseNo = map['houseNo'],
        locality = map['locality'],
        city = map['city'],
        state = map['state'];

  Map<String, dynamic> toMap() {
    return {
      'houseNo': houseNo,
      'locality': locality,
      'city': city,
      'state': state,
    };
  }

  @override
  String toString() {
    return 'Address: $houseNo, $locality, $city, $state\n';
  }

  @override
  List<Object> get props => [houseNo, locality, city, state];
}
