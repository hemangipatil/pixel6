import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Customer_Provider.dart';
import 'Customer_Form_Screen.dart';

class CustomerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer List')),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.customers.length,
            itemBuilder: (context, index) {
              final customer = provider.customers[index];
              return ListTile(
                title: Text(customer.fullName),
                subtitle: Text(customer.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerFormScreen(customer: customer), // Pass customer here
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteCustomer(customer.pan);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerFormScreen(customer: null,)), // No customer is passed here
          );
        },
      ),
    );
  }
}