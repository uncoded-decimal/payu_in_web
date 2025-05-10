import 'package:flutter/material.dart';
import 'package:payu_in_web/payu_in_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Payu Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PayU.in Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: const Text(
          'Push the FAB to launch PayU.in web checkout',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkout,
        tooltip: 'Checkout',
        child: const Icon(Icons.payments_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _checkout() {
    FlutterPayuWeb.checkout(
      merchantKey: "",
      salt: "",
      transactionId: "PAYUTST${DateTime.timestamp().millisecondsSinceEpoch}",
      amountAsDouble: 10,
      product: "demo",
      firstName: "TEST",
      lastName: "USER",
      email: "testuser@dummy.com",
      phone: "9090909090",
      sUrl: "https://cbjs.payu.in/sdk/success",
      fUrl: "https://cbjs.payu.in/sdk/failure",
      launchNewTab: true,
      pg: "TESTNB",
      bankcode: "TESTHDFC",
      enforcePaymentMethod: 'netbanking|creditcard|debitcard',
    );
  }
}
