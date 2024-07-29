import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api_services/Api_Services.dart';
import '../model/Customer_Model.dart';
import '../provider/Customer_Provider.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  CustomerFormScreen({required this.customer});

  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late TextEditingController _panController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late List<Address> _addresses;

  @override
  void initState() {
    super.initState();
    _panController = TextEditingController(text: widget.customer?.pan ?? '');
    _fullNameController = TextEditingController(text: widget.customer?.fullName ?? '');
    _emailController = TextEditingController(text: widget.customer?.email ?? '');
    _mobileController = TextEditingController(text: widget.customer?.mobileNumber ?? '');
    _addresses = widget.customer?.addresses ?? [];
  }

  String? validatePAN(String? value) {
    String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'PAN is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid PAN';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }

  String? validateMobile(String? value) {
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Mobile number is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid mobile number';
    }
    return null;
  }

  String? validatePostcode(String? value) {
    String pattern = r'^[0-9]{6}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Postcode is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid postcode';
    }
    return null;
  }

  Future<void> _updateAddressDetails(Address address) async {
    if (address.postcode.length == 6) {
      final result = await _apiService.getPostcodeDetails(address.postcode);
      setState(() {
        address.city = result['city'][0]['name'];
        address.state = result['state'][0]['name'];
      });
    }
  }

  void _addAddress() {
    setState(() {
      _addresses.add(Address(addressLine1: '', addressLine2: '', postcode: '', state: '', city: ''));
    });
  }

  void _removeAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  Widget _buildAddressForm(int index, Address address) {
    return Column(
      children: [
        TextFormField(
          initialValue: address.addressLine1,
          decoration: InputDecoration(labelText: 'Address Line 1'),
          validator: (value) => value!.isEmpty ? 'Address Line 1 is required' : null,
          onChanged: (value) {
            address.addressLine1 = value;
          },
        ),
        TextFormField(
          initialValue: address.addressLine2,
          decoration: InputDecoration(labelText: 'Address Line 2'),
          onChanged: (value) {
            address.addressLine2 = value;
          },
        ),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            } else {
              return await _apiService.searchPostcodes(textEditingValue.text);
            }
          },
          onSelected: (String selectedPostcode) {
            setState(() {
              address.postcode = selectedPostcode;
              _updateAddressDetails(address);
            });
          },
          fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(labelText: 'Postcode'),
              validator: validatePostcode,
              onChanged: (value) {
                address.postcode = value;
                _updateAddressDetails(address);
              },
            );
          },
        ),
        TextFormField(
          initialValue: address.city,
          decoration: InputDecoration(labelText: 'City'),
          enabled: false,
        ),
        TextFormField(
          initialValue: address.state,
          decoration: InputDecoration(labelText: 'State'),
          enabled: false,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _removeAddress(index),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _panController,
              decoration: InputDecoration(labelText: 'PAN'),
              validator: validatePAN,
              onChanged: (value) async {
                if (value.length == 10) {
                  final result = await _apiService.verifyPAN(value);
                  if (result['isValid']) {
                    setState(() {
                      _fullNameController.text = result['fullName'];
                    });
                  }
                }
              },
            ),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              maxLength: 140,
              validator: (value) => value!.isEmpty ? 'Full Name is required' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              maxLength: 255,
              validator: validateEmail,
            ),
            TextFormField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number (+91)'),
              maxLength: 10,
              validator: validateMobile,
            ),
            ..._addresses.asMap().entries.map((entry) {
              int index = entry.key;
              Address address = entry.value;
              return _buildAddressForm(index, address);
            }).toList(),
            ElevatedButton(
              onPressed: _addAddress,
              child: Text('Add Address'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final customer = Customer(
                    pan: _panController.text,
                    fullName: _fullNameController.text,
                    email: _emailController.text,
                    mobileNumber: _mobileController.text,
                    addresses: _addresses,
                  );
                  if (widget.customer == null) {
                    Provider.of<CustomerProvider>(context, listen: false).addCustomer(customer);
                  } else {
                    Provider.of<CustomerProvider>(context, listen: false).updateCustomer(customer);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(widget.customer == null ? 'Add Customer' : 'Update Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
