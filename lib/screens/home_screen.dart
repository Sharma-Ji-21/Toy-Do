import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 100,
                            backgroundImage: FileImage(_image!),
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
                          borderSide: BorderSide(color: Colors.black, width: 2),
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
                          borderSide: BorderSide(color: Colors.black, width: 2),
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
                          borderSide: BorderSide(color: Colors.black, width: 2),
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
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Starting Building"),
            ),
            body: Stack(
              children: [
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
          );
  }

  void fetchData() {
    print("Data has been fetched");
  }

  void addToWishList() {
    print("added to WishList");
    setState(() {
      toyNameController.clear();
      toyPriceController.clear();
      toyLinkController.clear();
      _image = null;
      isAdding = !isAdding;
    });
  }
}
