import 'package:flutter/material.dart';
import 'package:woo_commerce_test/screen/product.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: ProductTest(),
      ),
    );
  }
}
