import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
                      itemCount: allToys.length + 8,
                      itemBuilder: (context, index) {
                        return Stack(children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, left: 13.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: MediaQuery.of(context).size.height / 7.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green),
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
                        ]);
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

  void fetchData() {
    FirebaseFirestore.instance.collection("Toys").get().then((value) {
      for (var doc in value.docs) {
        print(doc.data());
        setState(() {
          allToys.add(doc);
          print(allToys);
        });
      }
    }).catchError((error) {
      print("Failed to fetch data: $error");
      setState(() {
        allToys = [];
      });
    });
    print("Data has been fetched");
  }

  void addToWishList() async {
    print("added to WishList");
    var toyName = toyNameController.text.toString();
    var toyPrice = toyPriceController.text.toString();
    var toyLink = toyLinkController.text.toString();
    print(toyName);
    print(toyPrice);
    print(toyLink);
    var toyImage = await uploadToGithub();
    print(toyImage);
    FirebaseFirestore.instance.collection("Toys").add({
      "toyName": toyName,
      "toyPrice": toyPrice,
      "toyLink": toyLink,
      "toyImage": toyImage,
    }).then((value) {
      print("Toys Added Successfully");
      Fluttertoast.showToast(
          msg: "Toys Added Successfully!",
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 2);
    }).catchError((error) {
      print("Failed to Add Toys: $error");
      Fluttertoast.showToast(
          msg: "Failed to Add Toys",
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 2);
    });
    setState(() {
      toyNameController.clear();
      toyPriceController.clear();
      toyLinkController.clear();
      _image = null;
      isAdding = !isAdding;
    });
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
