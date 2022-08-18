import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';

import '../services/RouteManager.dart';

class Project extends StatefulWidget {
  Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.width * 0.04),
            child: Visibility(
              visible: 'project' == context.watch<ManageRoute>().Project,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04),
                  child: TextField(
                    // controller: _addressController,
                    // maxLines: 5,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.folder),
                      hintText: 'Enter Project Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04),
                  child: TextField(
                    // controller: _addressController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.message),
                      hintText: '\n\n  Enter Project Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.off(Project());
                      context.read<ManageRoute>().ChangeMessage('ProjectShow');
                    },
                    child: Text('Save')),
              ]),
              replacement: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Card(

                        // child: Padding(
                        // padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                      onTap: (() {
                        Get.to(Sepecies(), arguments: ['Observe', 4]);
                      }),
                      title: Text('Observation $index'),
                      subtitle: Text('Observer'),
                    ));
                  },
                ),
              ),
            ),
          ),
          // Visibility(
          //   visible: 'Message' == context.watch<ManageRoute>().Message,
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //         top: MediaQuery.of(context).size.height * 0.02,
          //         left: MediaQuery.of(context).size.width * 0.04,
          //         right: MediaQuery.of(context).size.width * 0.04),
          //     child: TextField(
          //       // controller: _addressController,
          //       maxLines: 5,
          //       decoration: InputDecoration(
          //         prefixIcon: const Icon(Icons.message),
          //         hintText: '\n\n  Enter Your Message',
          //         border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(30.0)),
          //       ),
          //     ),
          //   ),
          //   replacement: Padding(
          //       padding: EdgeInsets.only(
          //           top: MediaQuery.of(context).size.height * 0.02,
          //           left: MediaQuery.of(context).size.width * 0.04,
          //           right: MediaQuery.of(context).size.width * 0.04),
          //       child: Text(
          //         'Content of Message Here',
          //       )),
          // ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // Visibility(
          //   visible: 'Message' == context.watch<ManageRoute>().Message,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         Get.back();
          //       },
          //       child: Text('Send')),
          //   replacement: ElevatedButton(
          //       onPressed: () {
          //         Get.off(Message());
          //         context.read<ManageRoute>().ChangeMessage('Message');
          //       },
          //       child: Text('Reply')),
          // )
        ],
      ),
    );
  }
}
