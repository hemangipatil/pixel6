class Address {
  String addressLine1;
  String addressLine2;
  String postcode;
  String state;
  String city;

  Address({required this.addressLine1, required this.addressLine2, required this.postcode, required this.state, required this.city});
}

class Customer {
  String pan;
  String fullName;
  String email;
  String mobileNumber;
  List<Address> addresses;

  Customer({required this.pan, required this.fullName, required this.email, required this.mobileNumber, required this.addresses});
}
