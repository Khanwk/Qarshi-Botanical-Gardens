import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:qarshi_app/services/dbManager.dart';

class RequestAuth extends StatefulWidget {
  const RequestAuth({Key? key}) : super(key: key);

  @override
  State<RequestAuth> createState() => _RequestAuthState();
}

class _RequestAuthState extends State<RequestAuth> {
  DocumentSnapshot obId = Get.arguments;
  String val = "null";

  bool shouldpop() {
    context.read<ManageRoute>().ChangeSepecies("");
    // obId.clear();
    // Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return shouldpop();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text('Request Details'),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.red,
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, elevation: 0),
                      onPressed: (() {
                        if (val != 'null') {
                          FirebaseFirestore.instance
                              .collection('observers')
                              .doc(
                                  Provider.of<dbManager>(context, listen: false)
                                      .observerdoc['uid'])
                              .collection('observations')
                              .doc(obId['uid'])
                              .update({"status": val});
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please Select any option from below !',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 13.0);
                        }
                      }),
                      child: Row(
                        children: const [
                          Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.done)
                        ],
                      ))
                ],
              ),
              body: Column(children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: Image.network(context
                                          .watch<dbManager>()
                                          .observerdoc['image'])
                                      .image),
                              shape: BoxShape.circle,
                              color: Colors.white),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                        title: Text(
                          obId['BotanicalName'].toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        subtitle: Text(
                          context
                              .watch<dbManager>()
                              .observerdoc['name']
                              .toString(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: Image.network(obId['image1']).image),
                                color: Colors.white,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: RadioListTile(
                                tileColor: Colors.white,
                                activeColor: Colors.white,
                                title: const Text(
                                  "Approve",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: "approved",
                                groupValue: val,
                                onChanged: (value) {
                                  setState(() {
                                    val = value.toString();
                                  });
                                },
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              indent: 15,
                              thickness: 2,
                              endIndent: 0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: RadioListTile(
                                tileColor: Colors.white,
                                activeColor: Colors.white,
                                title: const Text("Decline",
                                    style: TextStyle(color: Colors.white)),
                                value: "declined",
                                groupValue: val,
                                onChanged: (value) {
                                  setState(() {
                                    val = value.toString();
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                    isScrollable: true,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.red,
                    tabs: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Center(
                                child: Text(
                                  'Genral Info',
                                  style: TextStyle(fontSize: 19),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Center(
                                child: Text('Chracteristics',
                                    style: TextStyle(fontSize: 19)),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Center(
                                  child: Text('Habitat',
                                      style: TextStyle(fontSize: 19))),
                            ],
                          )),
                      // Visibility(
                      //   visible: args[0] != 'Sepecies',
                      //   child: SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.3,
                      //       height: MediaQuery.of(context).size.height * 0.07,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: const [
                      //           Center(
                      //               child: Text('Comments',
                      //                   style: TextStyle(fontSize: 19))),
                      //         ],
                      //       )),
                      //   replacement: const Text(''),
                      // )
                    ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(children: [
                    SingleChildScrollView(
                      child: DataTable(
                          // horizontalMargin: 0,
                          headingRowHeight: 0,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Genral Info',
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                            DataColumn(
                              label: Text('Chracteristics',
                                  style: TextStyle(fontSize: 19)),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Botanical Name')),
                                DataCell(
                                    Text(obId['BotanicalName'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Urdu Name')),
                                DataCell(Text(obId['LocalName'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('English Name')),
                                DataCell(Text(obId['EnglishName'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('family')),
                                DataCell(Text(obId['Family'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Desciption')),
                                DataCell(
                                  Tooltip(
                                    showDuration: const Duration(seconds: 5),
                                    waitDuration: const Duration(seconds: 1),
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    message: obId['Description'].toString(),
                                    triggerMode: TooltipTriggerMode.tap,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.grey),
                                    child: Text(
                                      (obId['Description'].toString()),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                          ]),
                    ),
                    SingleChildScrollView(
                      child: DataTable(headingRowHeight: 0, columns: const <
                          DataColumn>[
                        DataColumn(
                          label: Text(
                            'Genral Info',
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                        DataColumn(
                          label: Text('Chracteristics',
                              style: TextStyle(fontSize: 19)),
                        ),
                      ], rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Life Span:')),
                            DataCell(Text(obId['LifeSpan'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Blooming Period:')),
                            DataCell(Text(obId['BloomingPeriod'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Plant Height:')),
                            DataCell(Text(obId['PlantHeight'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Plant Spread:')),
                            DataCell(Text(obId['PlantSpread'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Habitat:')),
                            DataCell(Text(obId['Habitat'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Inflorescence:')),
                            DataCell(Text(obId['Inflorescense'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Flower Shape:')),
                            DataCell(Text(obId['FlowerShape'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Flower Color :')),
                            DataCell(Text(obId['FruitColor'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Stem Shape :')),
                            DataCell(Text(obId['StemShape'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Root Type :')),
                            DataCell(Text(obId['RootType'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                      ]),
                    ),
                    SingleChildScrollView(
                      child: DataTable(
                          headingRowHeight: 0,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                '',
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                            DataColumn(
                              label: Text('Chracteristics',
                                  style: TextStyle(fontSize: 19)),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Sunlight')),
                                DataCell(Text(obId['SunLight'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Temprature')),
                                DataCell(Text(obId['Temperature'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Soil')),
                                DataCell(Text(obId['Soil'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Water')),
                                DataCell(Text(obId['Water'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(Text('Propagation')),
                                DataCell(Text(obId['Propagation'].toString())),
                                // DataCell(Text('Professor')),
                              ],
                            ),
                          ]),
                    ),
                    // Container(
                    //   CupertinoFormRow(
                    //       prefix: Text('Botanical Name'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Urdu Name'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('English Name'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('family'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Desciption'), child: Text('Abc')),
                    // )

                    // Column(children: const [
                    //
                    // ]),
                    // Column(children: const [
                    //   CupertinoFormRow(
                    //       prefix: Text('Life Span:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Blooming Period:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Plant Height:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Plant Spread:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Habitat:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Inflorescence:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Flower Shape:'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Flower Color :'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Stem Shape :'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Root Type :'), child: Text('Abc')),
                    // ]),
                    // Column(children: const [
                    //   CupertinoFormRow(
                    //       prefix: Text('Sunlight'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Temprature'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Soil'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Water'), child: Text('Abc')),
                    //   CupertinoFormRow(
                    //       prefix: Text('Propagation'), child: Text('Abc')),
                    // ]),
                  ]),
                ),
              ]),
            ),
          ),
        ));
  }
}
