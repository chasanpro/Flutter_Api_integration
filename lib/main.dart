import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:urbanmatch/brief.dart';
import 'package:urbanmatch/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const MyHomePage(
          title: "URBANMATCH",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List posts = [];
  int len = 0;
  List mapResponse = [];
  List dataResponse = [];
  bool isLoaded = false;

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  Future apiCall() async {
    var client = http.Client();
    var uri = Uri.parse("https://api.github.com/users/freeCodeCamp/repos");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      mapResponse = jsonDecode(response.body);
      mapResponse.forEach((element) {
        dataResponse.add({
          'name':
              element['full_name'].toString().replaceAll('freeCodeCamp/', ''),
          'image': element['owner']['avatar_url'],
          'language': element['language'],
          'link': element['commits_url'].toString().replaceAll("{/sha}", ""),
        });
      });
      setState(() {
        dataResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;
    return Material(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "GITHUB API INTEGRATION ASSIGNMENT",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradcolor,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 0.3, 0.45, 0.8]),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    child: ListView.separated(
                      itemCount: dataResponse.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => info(
                                        url: dataResponse[index]['link'],
                                      )),
                            );
                          },
                          child: Container(
                              height: 120,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: x / 8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.network(
                                        dataResponse[index]['image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CardText("Name"),

                                      CardText("Language"),

                                      // Text(dataResponse[index]['lang']),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: CardText(
                                            dataResponse[index]['name']),
                                      ),

                                      CardText(dataResponse[index]
                                              ['language'] ??
                                          "Unspecified"),

                                      // Text(dataResponse[index]['lang']),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

CardText(String label) {
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
