import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ResearcherAddNew extends StatefulWidget {
  ResearcherAddNew({Key? key}) : super(key: key);

  @override
  State<ResearcherAddNew> createState() => _ResearcherAddNewState();
}

class _ResearcherAddNewState extends State<ResearcherAddNew> {
  String? dropdownvalue;
  File? image1;
  File? image2;
  File? image3;
  var items = [
    'Add Plant',
    'Add Book',
  ];

  Future pickImage(source, image, int NoOFPic) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      if (NoOFPic == 1) {
        setState(() {
          this.image1 = imageTemp;
        });
      } else if (NoOFPic == 2) {
        setState(() {
          this.image2 = imageTemp;
        });
      } else if (NoOFPic == 3) {
        setState(() {
          this.image3 = imageTemp;
        });
      }
    } on PlatformException catch (e) {
      print('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07,
                  right: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1),
              child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.red),
                    hintText: "Select to Add",
                  ),
                  value: dropdownvalue,
                  items: items
                      .map((items) =>
                          DropdownMenuItem(value: items, child: Text(items)))
                      .toList(),
                  onChanged: (String? Value) {
                    setState(() {
                      dropdownvalue = Value ?? "";
                    });
                  }),
            ),
            Visibility(
                visible: dropdownvalue == 'Add Book',
                child: Column(
                  children: [
                    CupertinoFormSection(
                        header: Text('Book Detail'),
                        children: [
                          CupertinoTextFormFieldRow(
                            prefix: Text('Book Name : '),
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: Text('Link : '),
                          )
                        ]),
                    ElevatedButton(onPressed: null, child: Text('Save'))
                  ],
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Visibility(
                visible: dropdownvalue == 'Add Plant',
                child: Column(
                  // shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image1 == null,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                child: Icon(Icons.add_a_photo),
                                onPressed: () =>
                                    pickImage(ImageSource.camera, image1, 1),
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    side: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            replacement: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: image1 == null
                                    ? Text('No image to show')
                                    : Image.file(image1!)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image2 == null,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                child: Icon(Icons.add_a_photo),
                                onPressed: () {
                                  pickImage(ImageSource.camera, image2, 2);
                                },
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    side: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            replacement: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: image2 == null
                                    ? Text('No image to show')
                                    : Image.file(image2!)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image3 == null,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                child: Icon(Icons.add_a_photo),
                                onPressed: () =>
                                    pickImage(ImageSource.camera, image3, 3),
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    side: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            replacement: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: image3 == null
                                    ? Text('No image to show')
                                    : Image.file(image3!)),
                          ),
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      header: const Text('Plant Information :'),
                      children: [
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Botanical Name:'),
                          placeholder: 'Enter Botanical Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Urdu Name :    '),
                          placeholder: 'Enter Urdu Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('English Name : '),
                          placeholder: 'Enter English Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Family :        '),
                          placeholder: 'Enter Family Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Desciption :   '),
                          placeholder: 'Enter Description',
                        )
                      ],
                    ),
                    CupertinoFormSection(
                        header: const Text('Chracteristics'),
                        children: [
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Life Span:'),
                            // placeholder: '',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Blooming Period: '),
                            // placeholder: 'Enter Urdu Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Plant Height: '),
                            // placeholder: 'Enter English Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Plant Spread :        '),
                            // placeholder: 'Enter Family Nam',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Habitat:   '),
                            // placeholder: 'Enter Description',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Inflorescence :'),
                            // placeholder: 'Enter Botanical Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Flower Shape :    '),
                            // placeholder: 'Enter Urdu Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Flower Color : '),
                            // placeholder: 'Enter English Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Leaf Type : '),
                            // placeholder: 'Enter Family Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Leaf Colour :   '),
                            // placeholder: 'Enter Description',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Fruit Type :'),
                            // placeholder: 'Enter Botanical Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Fruit Color : '),
                            // placeholder: 'Enter Urdu Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Stem Shape : '),
                            // placeholder: 'Enter English Name',
                          ),
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Root Type : '),
                            // placeholder: 'Enter Family Name',
                          ),
                        ]),
                    CupertinoFormSection(
                      header: const Text('Habitat :'),
                      children: [
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Sunlight :'),
                          // placeholder: 'Enter Botanical Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Temprature : '),
                          // placeholder: 'Enter Urdu Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Soil : '),
                          // placeholder: 'Enter English Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Water : '),
                          // placeholder: 'Enter Family Name',
                        ),
                        CupertinoTextFormFieldRow(
                          prefix: const Text('Propagation : '),
                          // placeholder: 'Enter Description',
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            image1 = null;
                            image2 = null;
                            image3 = null;
                          });
                        },
                        child: Text('Save')),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
