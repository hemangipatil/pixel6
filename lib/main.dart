import 'package:flutter/material.dart';
import 'package:pixel6assigment/provider/Customer_Provider.dart';
import 'package:pixel6assigment/screens/Customer_List_Screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerProvider(),
      child: MaterialApp(
        title: 'Customer Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CustomerListScreen(),
      ),
    );
  }
}
