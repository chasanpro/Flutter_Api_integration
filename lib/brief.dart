import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class info extends StatefulWidget {
  info({super.key, required this.url});
  final String url;

  @override
  State<info> createState() => _infoState();
}

class _infoState extends State<info> {
  List posts = [];
  int len = 0;
  List mapResponse = [];
  List briefResponse = [];
  bool isLoaded = false;
  Future apiCallV2() async {
    var client = http.Client();
    var uri = Uri.parse(widget.url);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      briefResponse.clear();
      mapResponse = jsonDecode(response.body);
      mapResponse.forEach((element) {
        briefResponse.add({
          'name': element['commit']['author']['name'],
          'mail': element['commit']['author']['email'],
          'date': element['commit']['author']['date'],
          'message': element['commit']['message'],
        });
      });
      setState(() {
        briefResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    apiCallV2();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0,
      ),
      child: Material(
        child: Scaffold(
          floatingActionButton: BackButton(
            color: Colors.purpleAccent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Brief Commit Log ",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 30, 161, 255),
                      ),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: briefResponse.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Column(
                          children: [
                            LogText(briefResponse[index]['name']),
                            LogText(briefResponse[index]['image'] ?? ''),
                            LogText(briefResponse[index]['message'] ?? ''),
                            LogText(briefResponse[index]['mail'] ?? ''),
                            LogText(briefResponse[index]['date'] ?? ''),
                          ],
                        ));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

LogText(String label) {
  return Text(
    label.trim(),
    style: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: Colors.black,
      ),
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
  );
}
