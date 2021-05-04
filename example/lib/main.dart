import 'package:esewa_pnp/esewa.dart';
import 'package:flutter/material.dart';

import 'package:esewa_pnp/esewa_pnp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ESewaPnp _esewaPnp;
  ESewaConfiguration _configuration;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _configuration = ESewaConfiguration(
      clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      environment: ESewaConfiguration.ENVIRONMENT_TEST,
    );
    _esewaPnp = ESewaPnp(configuration: _configuration);
  }

  double _amount = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(65, 161, 36, 1),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("ESewa PNP"),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _amount = double.parse(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: "Enter amount",
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ESewaPaymentButton(
                this._esewaPnp,
                amount: _amount,
                callBackURL: "https://example.com",
                productId: "abc123",
                productName: "Flutter SDK Example",
                onSuccess: (result) {
                  ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(
                      Color.fromRGBO(65, 161, 36, 1), result.message));
                },
                onFailure: (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(_buildSnackBar(Colors.red, e.message));
                },
              ),
              SizedBox(
                height: 84,
              ),
              Text(
                "Plugin developed by Ashim Upadhaya.",
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSnackBar(Color color, String msg) {
    return SnackBar(
      backgroundColor: color,
      content: Text(msg),
    );
  }
}
