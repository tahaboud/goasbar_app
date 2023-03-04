import 'package:flutter/material.dart';
import 'package:goasbar/ui/views/payment_form.dart';

class custom_UI extends StatefulWidget {
  @override
  _custom_UIState createState() => _custom_UIState();
}

String _checkoutid = '';
String _resultText = '';
String _MadaRegexV = "";
String _MadaRegexM = "";
String _MadaHash = "";

class _custom_UIState extends State<custom_UI> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom UI'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Credit Card'),
                    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => payment_form(type: "credit"),
    ), ); },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(22, 0, 22, 0)),
                    ),

                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text('Mada'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => payment_form(type: "mada"),
                        ), ); },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(22, 0, 22, 0)),
                    ),                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
