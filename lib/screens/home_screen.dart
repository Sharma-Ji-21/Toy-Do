import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool isUploading = false;
  List allToys = [];
  bool isAdding = false;
  var toyNameController = TextEditingController();
  var toyLinkController = TextEditingController();
  var toyPriceController = TextEditingController();

  final String githubToken = dotenv.env['GITHUB_TOKEN'] ?? '';
  final String username = dotenv.env['USERNAME'] ?? '';
  final String repo = dotenv.env['REPO'] ?? '';
  final String folderPath = dotenv.env['FOLDER_PATH'] ?? '';

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isAdding
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Add Item",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18.0, bottom: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _image != null
                          ? GestureDetector(
                              onTap: pickImage,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: FileImage(_image!),
                              ),
                            )
                          : GestureDetector(
                              onTap: pickImage,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 110,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      TextField(
                        controller: toyNameController,
                        decoration: InputDecoration(
                          hintText: "...",
                          labelText: "Toy Name",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: toyLinkController,
                        decoration: InputDecoration(
                          hintText: "link",
                          labelText: "Toy Link",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: toyPriceController,
                        decoration: InputDecoration(
                          hintText: "Price in ₹",
                          labelText: "Toy Price",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: addToWishList,
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                          ),
                          child: Center(
                              child: Text(
                            "Add Toy to WishList",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("data"),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1.5),
                      itemCount: allToys.length,
                      itemBuilder: (context, index) {
                        bool havingImage =
                            allToys[index]["toyImage"].toString().isNotEmpty;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0, left: 13.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.35,
                                  height:
                                      MediaQuery.of(context).size.height / 7.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                right: 3,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.dangerous_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 17,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 55,
                                  backgroundImage: havingImage
                                      ? NetworkImage(allToys[index]["toyImage"])
                                      : null,
                                  child: !havingImage
                                      ? const Text(
                                          "No Image",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                  right: 20,
                                  top: 33,
                                  child: Container(
                                    // height: 40,
                                    width: 73,
                                    // color: Colors.red,
                                    child: Center(
                                      child: Text(
                                        allToys[index]["toyName"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  right: 20,
                                  top: 75,
                                  child: Container(
                                    // height: 40,
                                    width: 73,
                                    // color: Colors.red,
                                    child: Center(
                                      child: Text(
                                        "₹${allToys[index]["toyPrice"]}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                right: 3,
                                bottom: 0,
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Purchased",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isAdding = !isAdding;
                        });
                        print("Button has been clicked");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red),
                        height: 75,
                        width: 75,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void fetchData() async {
    databaseRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          allToys = data.entries
              .map((e) => {
                    "key": e.key,
                    ...e.value,
                  })
              .toList();
        });
      }
    }).catchError((error) {
      print("Failed to fetch data: $error");
      setState(() {
        allToys = [];
      });
    });
  }

  final databaseRef = FirebaseDatabase.instance.ref("Toys");

  void addToWishList() async {
    var toyImage = await uploadToGithub();
    var toyName = toyNameController.text.toString();
    var toyPrice = toyPriceController.text.toString();
    var toyLink = toyLinkController.text.toString();

    final newToyRef = databaseRef.push();
    await newToyRef.set({
      "toyName": toyName,
      "toyPrice": toyPrice,
      "toyLink": toyLink,
      "toyImage": toyImage,
      "toyPurchased": false,
    });

    Fluttertoast.showToast(
        msg: "Toy Added Successfully!",
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 2);

    setState(() {
      toyNameController.clear();
      toyPriceController.clear();
      toyLinkController.clear();
      _image = null;
      isAdding = !isAdding;
    });
    fetchData();
  }

  Future<String> uploadToGithub() async {
    if (_image == null) return "";

    setState(() => isUploading = true);

    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);
    final fileName = _image!.path.split('/').last;

    final url = Uri.parse(
      'https://api.github.com/repos/$username/$repo/contents/$folderPath/$fileName',
    );

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $githubToken',
        'Accept': 'application/vnd.github+json',
      },
      body: jsonEncode({
        "message": "upload image $fileName",
        "content": base64Image,
      }),
    );

    setState(() => isUploading = false);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final downloadUrl = responseData['content']['download_url'];

      Fluttertoast.showToast(
        msg: "Uploaded successfully!",
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 2,
      );

      return downloadUrl;
    } else {
      Fluttertoast.showToast(
        msg: "Uploaded Failed! ${response}",
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 2,
      );

      return "";
    }
  }
}
