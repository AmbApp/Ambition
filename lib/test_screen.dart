import 'dart:math';

import 'package:ambition_app/config/sizeconfig/size_config.dart';
import 'package:flutter/material.dart';

class AddItemsScreen extends StatefulWidget {
  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final List<Map<String, dynamic>> items = [];
  String item = '';
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> selected = [];
  TextEditingController itemTextController = TextEditingController();
  bool isHidden = true;
  bool hiddenItem = true;
  Map<String, dynamic> extras = {
    'requirestTwoPeople': false,
    'carryUpAndDowntheStairs': false,
    'peopleTaggingAlong': 0
  };
  String? itemNotInList;
  List<Map<String, String>> dataSourceCords = [];

  final options = [
    {'name': 'Basement'},
    {'name': 'Ground floor'},
    {'name': '1st floor'},
    {'name': '2nd floor'},
    {'name': '3rd floor'},
    {'name': '4th floor'},
    {'name': '5th floor'},
    {'name': '6th floor'},
    {'name': '7th floor'},
    {'name': 'Above 8th floor'},
  ];

  String? origin;
  String? destination;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    HandleFetch();
  }

  void HandleScroll() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  Future<void> HandleFetch() async {}

  void searchFilterFunction(String? it) {
    final itemData = <Map<String, String>>[];

    if (it != null) {
      data.where((item) => item['name'].contains(it)).forEach((filteredItem) {
        itemData.add({
          'id': filteredItem['_id'],
          'name': filteredItem['name'],
        });
      });
      itemNotInList = it;
    }
  }

  void increaseItemQuantity(int index) {}

  void HandleIncreaseCount() {
    setState(() {
      extras['peopleTaggingAlong']++;
    });
  }

  void HandleDecreaseCount() {
    setState(() {
      extras['peopleTaggingAlong'] = extras['peopleTaggingAlong'] <= 0
          ? 0
          : extras['peopleTaggingAlong'] - 1;
    });
  }

  void HandlePeopleCheckBox(bool isChecked) {
    setState(() {
      extras['requirestTwoPeople'] = isChecked;
    });
  }

  void HandleCarryCheckBox(bool isChecked) {
    setState(() {
      extras['carryUpAndDowntheStairs'] = isChecked;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      HandleScroll();
    });
  }

  void decreaseItemQuantity(int index) {}

  void removeFromSelected() {
    final removeIndex = selected.indexWhere((item) => item['qty'] == 0);
    if (removeIndex > -1) {
      setState(() {
        selected.removeAt(removeIndex);
      });
    }
  }

  void HandleHide() {
    setState(() {
      isHidden = true;
    });
  }

  void HandleHideNewItemWidget() {
    setState(() {
      hiddenItem = true;
    });
  }

  void UpdateItems(Map<String, dynamic> data, String itemName, int width,
      int height, int depth) {}

  void HandleAddNonExistingItem(int width, int height, int depth) {
    final selectedItems = [
      {
        'selected_id': 'item_${(0 + new Random().nextInt(100))}',
        'name': itemNotInList,
        'qty': 1,
        'width': width,
        'height': height,
        'depth': depth,
      },
    ];
    setState(() {
      selected.addAll(selectedItems);
      hiddenItem = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ItemDimensions(
                getItemName: item,
                externalState: isHidden,
                hideFunction: HandleHide,
                data: selected,
                updateFunction: UpdateItems,
              ),
              // AddNonExistingItem(
              //   getItemName: itemNotInList,
              //   externalState: hiddenItem,
              //   hideFunction: HandleHideNewItemWidget,
              //   updateFunction: HandleAddNonExistingItem,
              // ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, size: 30),
                        Text('Back'),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 70,
                      child: Column(
                        children: [
                          Icon(Icons.search),
                          TextField(
                            onChanged: (text) => searchFilterFunction(text),
                            decoration: InputDecoration(
                              hintText: 'Add item(s) manually',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (itemNotInList != null) {
                                hiddenItem = false;
                              }
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        hiddenItem = false;
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Scan'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    FutureBuilder<List<Map<String, String>>>(
                      // future: HandleFetchCordinates(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            height: 200,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              items: options.map((data) {
                                return DropdownMenuItem<String>(
                                  child: new Text(
                                    data['name'] as String,
                                  ),
                                  value: data['name'] as String,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                origin = value;
                                // print('origin ==> $origin');
                              },
                              hint: Text(
                                "Select an option...",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (item != null)
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: extras['requirestTwoPeople'],
                                  onChanged: (bool? value) =>
                                      HandlePeopleCheckBox(value!),
                                ),
                              ),
                              Text('2'),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: extras['carryUpAndDowntheStairs'],
                                  onChanged: (bool? value) =>
                                      HandleCarryCheckBox(value!),
                                ),
                              ),
                              Text('Carry up/down stairs'),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: IconButton(
                                  onPressed: () => HandleIncreaseCount(),
                                  icon: Icon(Icons.arrow_upward),
                                ),
                              ),
                              Text('${extras['peopleTaggingAlong']}'),
                              Container(
                                width: 20,
                                height: 20,
                                child: IconButton(
                                  onPressed: () => HandleDecreaseCount(),
                                  icon: Icon(Icons.arrow_downward),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              // Column(
              //   children: <Widget>[
              //     ListView.builder(
              //       itemCount: selected.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         final item = selected[index];
              //         return Dismissible(
              //           key: Key(item['selected_id'].toString()),
              //           onDismissed: (direction) {
              //             setState(() {
              //               selected.removeAt(index);
              //             });
              //           },
              //           child: Container(
              //             child: Card(
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: <Widget>[
              //                   Text(item['name']),
              //                   Row(
              //                     children: [
              //                       IconButton(
              //                         onPressed: () =>
              //                             increaseItemQuantity(index),
              //                         icon: Icon(Icons.add),
              //                       ),
              //                       Text('${item['qty']}'),
              //                       IconButton(
              //                         onPressed: () =>
              //                             decreaseItemQuantity(index),
              //                         icon: Icon(Icons.remove),
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     Container(
              //       width: 200,
              //       child: ElevatedButton(
              //         onPressed: () {
              //           Navigator.pop(
              //               context, {'selected': selected, 'extras': extras});
              //         },
              //         child: Text('Done'),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDimensions extends StatelessWidget {
  final String getItemName;
  final bool externalState;
  final Function hideFunction;
  final List<Map<String, dynamic>> data;
  final Function updateFunction;

  ItemDimensions({
    required this.getItemName,
    required this.externalState,
    required this.hideFunction,
    required this.data,
    required this.updateFunction,
  });

  double width = 0.0;
  double height = 0.0;
  double depth = 0.0;

  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    return Container(
      color: Colors.black.withOpacity(0.6),
      // height: config.uiHeightPx * 0.2,
      width: config.uiWidthPx * 1,
      child: Center(
        child: Container(
          width: 95.0,
          padding: EdgeInsets.only(bottom: 2.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "Tell us the dimensions for:",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      getItemName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Enter Manually",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        Text("Width",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(hintText: "Width(cm)"),
                            onChanged: (value) {
                              width = double.tryParse(value) ?? 0.0;
                            },
                          ),
                        ),
                        Text("Height",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(hintText: "Height(cm)"),
                            onChanged: (value) {
                              height = double.tryParse(value) ?? 0.0;
                            },
                          ),
                        ),
                        Text("Length",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(hintText: "Length(cm)"),
                            onChanged: (value) {
                              depth = double.tryParse(value) ?? 0.0;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Or"),
                        SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            // Implement the measure functionality here
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  "Measure",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.rule_sharp,
                                  size: 25.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: hideFunction as void Function()?,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () => updateFunction(
                              data, getItemName, width, height, depth),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue[400]!),
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blue[400],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
