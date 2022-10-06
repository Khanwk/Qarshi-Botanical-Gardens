import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../services/RouteManager.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
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
              visible: 'Message' == context.watch<ManageRoute>().Message,
              child: Row(
                children: const [
                  Text(
                    'To:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text('   Observer Name', style: TextStyle(fontSize: 18))
                ],
              ),
              replacement: Row(
                children: const [
                  Text(
                    'From:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text('   Observer Name', style: TextStyle(fontSize: 18))
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Visibility(
            visible: 'Message' == context.watch<ManageRoute>().Message,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04),
              child: TextField(
                // controller: _addressController,
                maxLines: 5,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.message),
                  hintText: '\n\n  Enter Your Message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
            replacement: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04),
                child: const Text(
                  'Content of Message Here',
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Visibility(
            visible: 'Message' == context.watch<ManageRoute>().Message,
            child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Send')),
            replacement: ElevatedButton(
                onPressed: () {
                  Get.off(const Message());
                  context.read<ManageRoute>().ChangeMessage('Message');
                },
                child: const Text('Reply')),
          )
        ],
      ),
    );
  }
}
