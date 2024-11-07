import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/auth_provider.dart';
import 'package:woo_commerce_test/screen/product.dart';
import 'package:woo_commerce_test/screen/signup.dart';

class Login extends ConsumerWidget {
  Login({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductTest()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: authState.isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  final notifier =
                                      ref.read(authNotifierProvider.notifier);
                                  await notifier.login(_emailController.text,
                                      _passwordController.text);
                                },
                          child: authState.isLoading
                              ? CircularProgressIndicator()
                              : Text('Login'),
                        ),
                        if (authState.error != null) ...[
                          SizedBox(height: 8),
                          Text(authState.error!,
                              style: TextStyle(color: Colors.red)),
                        ],
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => Signup()));
                            },
                            child: Text("Don't have an account? Sign Up"))
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
