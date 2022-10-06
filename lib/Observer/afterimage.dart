import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  File image = Get.arguments;
  List plantName = ['Rose', 'Lavender', 'Mapel'];
  List plantProb = ['91.1 %', '92 %', '99 %'];
  // List<File> plantImage = [File.image, File.image];

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Results',
              style: TextStyle(color: Colors.red),
            ),
          ),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: image == null
                      ? const Text('No image to show')
                      : Image.file(image)),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ), // RoundedRectangleBorder
                          child: Column(children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: image == null
                                      ? const Text('No image to show')
                                      : Image.file(
                                          image,
                                          fit: BoxFit.cover,
                                        ),
                                ), // Ink.image
                              ],
                            ),
                            Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 216, top: 5),
                                  child: Text(
                                    ' Plant Name ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 260, bottom: 3),
                              child: Text(
                                '  78.2% ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),

                            // Text
                          ]));
                    } // Stack

                    ) // Card

                // Card(
                //   child: ListTile(
                //     onTap: () =>
                //         Get.to(const Sepecies(), arguments: ['Observe', 4]),
                //     leading: SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.2,
                //         width: MediaQuery.of(context).size.width * 0.25,
                //         child: image == null
                //             ? const Text('No image to show')
                //             : Image.file(image)),
                //     title: const Text('Observation'),
                //     trailing: const SizedBox(width: 40, child: Text('90 %')),
                //   ),
                // );
                ),
          ]));
    });
  }
}
