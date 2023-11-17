import 'dart:convert';

import 'package:dineapple/features/filter/services/api_service.dart';
import 'package:dineapple/utils/apptext.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../model/response_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Data?> searchData = [];
  List<Taxonomies> filteredData = [];
  Map<String, Set<Taxonomies>> selectedTaxonomies = {};
  Map<String, Set<String>> selectedOptions = {};

  String? grp1 = "near";

  Map<String, List<Taxonomies>> filteredDataMap = {};
  @override
  void initState() {
    final apiProvider = Provider.of<APIService>(context, listen: false);
    super.initState();
    searchData = apiProvider.cuisineData!.data!;

    for (var i in searchData) {
      if (i!.slug != null && i.slug != "location") {
        filteredDataMap[i.slug!] = i.taxonomies ?? [];
        selectedOptions[i.slug!] = <String>{}; // Initialize with an empty set
        selectedTaxonomies[i.slug!] = <Taxonomies>{}; // Init
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(searchData);
    // for(var i in searchData){
    //   print(i!.slug);
    //  if(i!.slug=="attire"){
    //  print(i!.name);
    //    filteredData.addAll(i!.taxonomies!);
    //  }
    //
    //
    // }
    // print(filteredData.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Options'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 5.0,
                      children: selectedOptions.entries
                          .map((entry) {
                            String section = entry.key;
                            Set<String> selectedOptions = entry.value;
                            List<Widget> chips = selectedOptions.map((option) {
                              return Chip(
                                backgroundColor: Colors.grey.shade200,
                                shape: StadiumBorder(
                                  side: BorderSide.none,
                                ),
                                deleteIconColor: Colors.grey.shade500,
                                label: Text(
                                  option,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    this
                                        .selectedOptions[section]!
                                        .remove(option);
                                    showToast(
                                        "Show: ${calculateTotalTaxonomiesCount()}");
                                  });
                                },
                              );
                            }).toList();
                            return chips;
                          })
                          .expand((chips) => chips)
                          .toList(),
                    ),

                    Card(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,bottom: 10,top: 20,),
                            child: AppText(data: "Sort by",fw: FontWeight.w700,size: 16,),
                          ),
                          RadioListTile(
                              fillColor: MaterialStateProperty.all(Colors.brown),
                            title: AppText(data: "Nearest to me (default)",),
                              value: "near",
                              groupValue: grp1,
                              onChanged: (value) {

                              setState(() {
                                grp1=value;
                              });
                              }),
                          RadioListTile(
                              fillColor: MaterialStateProperty.all(Colors.brown),
                              title: AppText(data: "Trending this Week",),
                              value: "trending",
                              groupValue: grp1,
                              onChanged: (value) {

                                setState(() {
                                  grp1=value;
                                });
                              }),
                          RadioListTile(
                              fillColor: MaterialStateProperty.all(Colors.brown),
                              title: AppText(data: "Newest Added",),
                              value: "new",
                              groupValue: grp1,
                              onChanged: (value) {

                                setState(() {
                                  grp1=value;
                                });
                              }),
                          RadioListTile(
                              fillColor: MaterialStateProperty.all(Colors.brown),
                              title: AppText(data: "Alphabetical",),
                              value: "alpha",
                              groupValue: grp1,
                              onChanged: (value) {

                                setState(() {
                                  grp1=value;
                                });
                              })
                        ],
                      ),
                    ),

                    for (var entry in filteredDataMap.entries)
                      Card(
                        child: ExpansionTile(
                          title: buildExpansionTileTitle(entry.key,
                              entry.value), // Use the slug as the title
                          children: generateCheckboxList(entry.key, entry.value),
                        ),
                      ),
                    SizedBox(height: 20,),
                    calculateTotalTaxonomiesCount()>0?


     Center(
       child: Container(
           height: 40,
           width: 200,
           decoration: BoxDecoration(
             color: Color(0xff3c3c3c),
             borderRadius: BorderRadius.circular(10)
           ),
           child: Center(child: Text("Show ${calculateTotalTaxonomiesCount()}",style: TextStyle(color: Colors.white),))),
     )
    :SizedBox(),



                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> expansionTileTitleCounts = {};
  void updateExpansionTileTitleCount(String section) {
    setState(() {
      // Update the count in the ExpansionTile title
      int selectedCount = selectedTaxonomies[section]!.length;
      expansionTileTitleCounts[section] = selectedCount;
    });
  }

  Widget buildExpansionTileTitle(String section, List<Taxonomies> taxonomies) {
    Set<Taxonomies> selectedTaxonomies = this.selectedTaxonomies[section]!;

    int selectedCount = expansionTileTitleCounts[section] ?? 0;
    return ListTile(
      title: Row(
        children: [
       AppText(data: "$section",color: Colors.black,size: 16,fw: FontWeight.bold,),
          SizedBox(
            width: 10,
          ),
          Text(
            "${selectedCount != 0 ? '($selectedCount)' : ''}",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  List<Widget> generateCheckboxList(
      String section, List<Taxonomies> taxonomies) {
    List<Widget> checkboxList = [];

    for (Taxonomies taxonomy in taxonomies) {
      checkboxList.add(
        ListTile(
          leading: customCheckbox(
            checked:
                selectedOptions[section]?.contains(taxonomy.slug.toString()) ??
                    false,
            onTap: (bool value) {
              setState(() {
                if (value) {
                  selectedOptions[section]!
                      .add(taxonomy.slug!); // Ensure taxonomy.slug is not null
                  selectedTaxonomies[section]!.add(taxonomy);
                  showToast("Show: ${calculateTotalTaxonomiesCount()}");
                } else {
                  selectedOptions[section]!.remove(
                      taxonomy.slug!); // Ensure taxonomy.slug is not null
                  selectedTaxonomies[section]!.remove(taxonomy);
                  showToast("Show: ${calculateTotalTaxonomiesCount()}");
                }

                updateExpansionTileTitleCount(section);
              });
            },
          ),
          title: Text(taxonomy.name.toString()),
        ),
      );
    }

    return checkboxList;
  }

  Widget customCheckbox({
    required bool checked,
    required ValueChanged<bool> onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(!checked),
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.0,
            color: Colors.brown,
          ),
          color: checked ? Colors.white : Colors.transparent,
        ),
        child: checked
            ? Padding(
                padding: const EdgeInsets.all(1.0),
                child: Icon(
                  Icons.radio_button_checked,
                  size: 18.0,
                  color: Colors.brown,
                ),
              )
            : null,
      ),
    );
  }



  int calculateTotalTaxonomiesCount() {

    var sum=0;
    int totalTaxonomiesCount = 0;
    for (var entry in selectedTaxonomies.entries) {
      print(entry.value.length);
      totalTaxonomiesCount += entry.value.length;
    }
    return totalTaxonomiesCount;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
