import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/Message.dart';
import 'package:qarshi_app/Observer/chat.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:qarshi_app/services/dbManager.dart';

class Sepecies extends StatefulWidget {
  const Sepecies({Key? key}) : super(key: key);

  @override
  State<Sepecies> createState() => _SepeciesState();
}

class _SepeciesState extends State<Sepecies> {
  DocumentSnapshot obId = Get.arguments;
  // String page = 'Sepecies';
  // String? page;
  // int? tabV;
  bool shouldpop() {
    context.read<ManageRoute>().ChangeSepecies("");
    // obId.clear();
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
                title: Visibility(
                  visible: "Sepecies" == context.watch<ManageRoute>().Sepecies,
                  child: const Text(
                    'Sepecies',
                    style: TextStyle(color: Colors.white),
                  ),
                  replacement: const Text(
                    'Observation',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.red,
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
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                        title: Text(
                          obId['BotanicalName'].toString(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        subtitle: Text(
                          context
                              .watch<dbManager>()
                              .observerdoc!['name']
                              .toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        trailing: Visibility(
                          visible: context
                                  .watch<dbManager>()
                                  .currentobserverdoc!['name'] !=
                              context.watch<dbManager>().observerdoc!['name'],
                          child: IconButton(
                              onPressed: () {
                                Get.to(const ChatPage(),
                                    arguments: Provider.of<dbManager>(context,
                                            listen: false)
                                        .observerdoc!['uid']);
                              },
                              icon: const Icon(
                                Icons.message,
                                color: Colors.white,
                              )),
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
                  child: FittedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
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
                    // SingleChildScrollView(
                    //   child: Column(
                    //     children: [
                    //       SizedBox(
                    //         height: 30,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Text('Botanical Name: '),
                    //             Text(obId['BotanicalName'].toString())
                    //           ],
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.black,
                    //       ),
                    //       SizedBox(
                    //         height: 30,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Text('Urdu Name: '),
                    //             Text(obId['LocalName'].toString())
                    //           ],
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.black,
                    //       ),
                    //       SizedBox(
                    //         height: 30,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Text('English Name:  '),
                    //             Text(obId['EnglishName'].toString())
                    //           ],
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.black,
                    //       ),
                    //       SizedBox(
                    //         height: 30,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Text('Family:  '),
                    //             Text(obId['Family'].toString())
                    //           ],
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.black,
                    //       ),
                    //       SizedBox(
                    //         height: 30,
                    //         width: MediaQuery.of(context).size.width,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text('Description:  '),
                    //             Text(obId['Description'].toString())
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    SingleChildScrollView(
                      child: DataTable(
                          // horizontalMargin: 0,
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
                          ], rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Botanical Name')),
                            DataCell(Text(obId['BotanicalName'].toString())),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
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
                      child: DataTable(columns: const <DataColumn>[
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
                            DataCell(Text('Life Span:')),
                            DataCell(Text(obId['LifeSpan'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Blooming Period:')),
                            DataCell(Text(obId['BloomingPeriod'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Plant Height:')),
                            DataCell(Text(obId['PlantHeight'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Plant Spread:')),
                            DataCell(Text(obId['PlantSpread'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Habitat:')),
                            DataCell(Text(obId['Habitat'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Inflorescence:')),
                            DataCell(Text(obId['Inflorescense'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Flower Shape:')),
                            DataCell(Text(obId['FlowerShape'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Flower Color :')),
                            DataCell(Text(obId['FruitColor'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Stem Shape :')),
                            DataCell(Text(obId['StemShape'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Root Type :')),
                            DataCell(Text(obId['RootType'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                      ]),
                    ),
                    SingleChildScrollView(
                      child: DataTable(columns: const <DataColumn>[
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
                      ], rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Sunlight')),
                            DataCell(Text(obId['SunLight'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Temprature')),
                            DataCell(Text(obId['Temperature'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Soil')),
                            DataCell(Text(obId['Soil'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Water')),
                            DataCell(Text(obId['Water'].toString())),
                            // DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Propagation')),
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
