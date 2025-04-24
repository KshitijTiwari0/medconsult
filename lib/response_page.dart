import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponsePage extends StatefulWidget {
  final Map<String, dynamic> data;

  const ResponsePage({Key? key, required this.data}) : super(key: key);

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  String responseText = "Loading...";

  @override
  void initState() {
    super.initState();
    _sendData();
  }

  Future<void> _sendData() async {
    final url = Uri.parse(
        'https://kshitij181.app.n8n.cloud/webhook-test/7afd299f-db64-45b6-a4c1-378c0e8517c4');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(widget.data),
      );

       if (response.statusCode == 200) {
        setState(() {
          if (response.body.isEmpty) {
            responseText = 'Data sent correctly';
          } else {
            responseText = response.body;
          }
        });
      } else {
        setState(() {
           responseText =
              'Error sending data: error code: ${response.statusCode} returned body: ${response.body}';
          });
          
       
      }
    } catch (e) {
      setState(() {
        responseText = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Response Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(responseText),
        ),
      ),
    );
  }
}