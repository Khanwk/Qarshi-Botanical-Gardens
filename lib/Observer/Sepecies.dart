import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/Message.dart';
import 'package:qarshi_app/services/RouteManager.dart';

class Sepecies extends StatefulWidget {
  Sepecies({Key? key}) : super(key: key);

  @override
  State<Sepecies> createState() => _SepeciesState();
}

class _SepeciesState extends State<Sepecies> {
  // String page = 'Sepecies';
  List args = Get.arguments;
  // String? page;
  // int? tabV;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: args[1],
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Visibility(
              visible: args[0] == 'Sepecies',
              child: Text(
                'Sepecies',
                style: TextStyle(color: Colors.white),
              ),
              replacement: Text(
                'Observation',
                style: TextStyle(color: Colors.white),
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.red,
          ),
          body: Column(
            children: [
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
                            shape: BoxShape.circle, color: Colors.white),
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      title: Visibility(
                        visible: args[0] == 'Sepecies',
                        child: Text(
                          'Species Name',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        replacement: Text(
                          'Observation Name',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      subtitle: Text(
                        'Observer Name',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Get.off(Message());
                            context
                                .read<ManageRoute>()
                                .ChangeMessage('Message');
                          },
                          icon: const Icon(
                            Icons.message,
                            color: Colors.white,
                          )),
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
                    Container(
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
                    Container(
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
                    Container(
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
                    Visibility(
                      visible: args[0] != 'Sepecies',
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Center(
                                  child: Text('Comments',
                                      style: TextStyle(fontSize: 19))),
                            ],
                          )),
                      replacement: Text(''),
                    )
                  ]),
              // TabBarView(children: [
              //   Column(children: const [
              //     CupertinoFormRow(
              //         prefix: Text('Botanical Name'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Urdu Name'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('English Name'), child: Text('Abc')),
              //     CupertinoFormRow(prefix: Text('family'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Desciption'), child: Text('Abc')),
              //   ]),
              //   Column(children: const [
              //     CupertinoFormRow(
              //         prefix: Text('Life Span:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Blooming Period:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Plant Height:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Plant Spread:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Habitat:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Inflorescence:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Flower Shape:'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Flower Color :'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Stem Shape :'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Root Type :'), child: Text('Abc')),
              //   ]),
              //   Column(children: const [
              //     CupertinoFormRow(
              //         prefix: Text('Sunlight'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Temprature'), child: Text('Abc')),
              //     CupertinoFormRow(prefix: Text('Soil'), child: Text('Abc')),
              //     CupertinoFormRow(prefix: Text('Water'), child: Text('Abc')),
              //     CupertinoFormRow(
              //         prefix: Text('Propagation'), child: Text('Abc')),
              //   ]),
              // ]),
            ],
          ),
        ),
      ),
    );
  }
}
