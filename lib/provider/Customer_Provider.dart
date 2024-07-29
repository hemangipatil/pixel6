import 'package:flutter/material.dart';

import '../model/Customer_Model.dart';


class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  void addCustomer(Customer customer) {
    _customers.add(customer);
    notifyListeners();
  }

  void updateCustomer(Customer customer) {
    final index = _customers.indexWhere((c) => c.pan == customer.pan);
    if (index != -1) {
      _customers[index] = customer;
      notifyListeners();
    }
  }

  void deleteCustomer(String pan) {
    _customers.removeWhere((c) => c.pan == pan);
    notifyListeners();
  }
}
