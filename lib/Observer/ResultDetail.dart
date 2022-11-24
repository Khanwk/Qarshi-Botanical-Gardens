import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Button extends StatefulWidget {
  const Button({Key? key}) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  List data = Get.arguments;
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Result",
            style: TextStyle(color: Colors.red),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    image: DecorationImage(
                  image: Image.network(
                    url == null
                        ? data[0]["results"][data[1]]["images"][0]["url"]["o"]
                            .toString()
                        : url.toString(),
                    fit: BoxFit.fill,
                  ).image,
                ))),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      url = data[0]["results"][data[1]]["images"][0]["url"]["o"]
                          .toString();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.network(data[0]["results"][data[1]]
                                          ["images"][0]["url"]["o"]
                                      .toString())
                                  .image)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      url = data[0]["results"][data[1]]["images"][1]["url"]["o"]
                          .toString();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.network(data[0]["results"][data[1]]
                                          ["images"][1]["url"]["o"]
                                      .toString())
                                  .image)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      url = data[0]["results"][data[1]]["images"][2]["url"]["o"]
                          .toString();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.network(data[0]["results"][data[1]]
                                          ["images"][2]["url"]["o"]
                                      .toString())
                                  .image)),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 9,
                height: MediaQuery.of(context).size.height * 0.33,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red[100]),
                child: Column(
                  children: [
                    DataTable(
                        // horizontalMargin: 0,
                        headingRowHeight: 0,
                        columns: <DataColumn>[
                          DataColumn(label: Container()),
                          DataColumn(
                            label: Container(),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Botanical Name')),
                              DataCell(Text(data[0]["results"][data[1]]
                                      ["species"]["scientificName"]
                                  .toString())),
                              // DataCell(Text('Professor')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Common Name')),
                              DataCell(Text(data[0]["results"][data[1]]
                                      ["species"]["commonNames"][1]
                                  .toString())),
                              // DataCell(Text('Professor')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('family')),
                              DataCell(Text(data[0]["results"][data[1]]
                                      ["species"]["family"]['scientificName']
                                  .toString())),
                              // DataCell(Text('Professor')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              const DataCell(Text('Similarity')),
                              DataCell(Text(data[0]["results"][data[1]]["score"]
                                  .toString())),
                              // DataCell(Text('Professor')),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
