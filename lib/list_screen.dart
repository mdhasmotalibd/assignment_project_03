import 'dart:convert';
import 'package:assingment/product.dart';
import 'package:assingment/photo_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

List<Photos> photosList = [];

bool loding = false;

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    getListFormApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Photo Gallery App"),
      ),
      body: photosList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: photosList.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailsScreen(
                            Title: photosList[index].title,
                            Imageurl: photosList[index].url,
                            id: photosList[index].id),
                      ));
                },
                title: Text(photosList[index].title ?? ""),
                leading: Image.network(photosList[index].thumbnailUrl ?? ""),
              ),
            ),
    );
  }

  Future<void> getListFormApi() async {
    setState(() {
      loding = true;
    });
    Uri myUrl = Uri.parse("https://jsonplaceholder.typicode.com/photos");
    Response response = await get(myUrl);
    if (response.statusCode == 200) {
      var responseDecode = jsonDecode(response.body);
      for (var i in responseDecode) {
        setState(() {
          Photos MyApiList = Photos.fromJson(i);
          photosList.add(MyApiList);
        });
      }
    } else {
      setState(() {
        loding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Product created successfully",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }
  }
}
