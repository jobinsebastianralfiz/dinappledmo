// import 'package:dineapple/features/location/location_provider.dart';
// import 'package:dineapple/utils/apptext.dart';
import 'dart:convert';

import 'package:dineapple/features/filter/services/api_service.dart';
import 'package:dineapple/features/filter/services/search_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../model/response_model.dart';

// import 'package:provider/provider.dart';
//
// import '../services/api_service.dart';
//
// class FilterOptions extends StatefulWidget {
//   const FilterOptions({super.key});
//
//   @override
//   State<FilterOptions> createState() => _FilterOptionsState();
// }
//
// class _FilterOptionsState extends State<FilterOptions> {
//   String?grp1="nearest";
//   @override
//   void initState() {
//
//     final locationProvider = Provider.of<LocationProvider>(context, listen: false);
//     final apiProvider = Provider.of<APIService>(context, listen: false);
//     locationProvider.determinePosition().then((_) {
//       if (locationProvider.currentLocationName != null) {
//         var city = locationProvider.currentLocationName!.locality;
//         apiProvider.loadCuisines();
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey,
//         title: AppText(data: "Filter Options",),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         padding: EdgeInsets.all(20),
//
//         child: Column(
//           children: [
//
//             Card(
//               child: Container(
//                 padding: EdgeInsets.all(20),
//
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: [
//                     RadioListTile(
//                         title: AppText(data: "Nearest to me (Deafult)",),
//                         value: "nearest", groupValue: grp1, onChanged: (value){}),
//                     RadioListTile(
//                         title: AppText(data: "Trending this Week",),
//                         value: "trending", groupValue: grp1, onChanged: (value){}),
//                     RadioListTile(
//                         title: AppText(data: "Newest Added",),
//                         value: "new", groupValue: grp1, onChanged: (value){}),
//                     RadioListTile(
//                         title: AppText(data: "Alphabetical",),
//                         value: "alpha", groupValue: grp1, onChanged: (value){}),
//
//                   ],
//                 ),
//               ),
//             )
//           ],
//
//         ),
//       ),
//     );
//   }
// }
//
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Data?> searchData = [];
  List<Taxonomies> filteredData = [];
  Map<String, Set<Taxonomies>> selectedTaxonomies = {};
  Map<String, Set<String>> selectedOptions = {};
  //Map<String, Taxonomies?> selectedTaxonomies = {};
//
//   @override
//   void initState() {
//
//     final apiProvider = Provider.of<APIService>(context, listen: false);
//     super.initState();
//     searchData=apiProvider.cuisineData!.data!;
//
//
//
// //print(searchData);
// }
//print(filteredData[0]['taxonomies']);

  Map<String, List<Taxonomies>> filteredDataMap = {};


  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    final apiProvider = Provider.of<APIService>(context, listen: false);
    searchData = apiProvider.cuisineData?.data ?? [];

    print(searchData);
    FilterProvider filterProvider = Provider.of<FilterProvider>(context, listen: false);
  print(filterProvider);
    for (var i in searchData) {
      if (i?.slug != null && i!.slug != "location") {
        filteredDataMap[i!.slug!] = i.taxonomies ?? [];
        filterProvider.selectedOptions[i.slug!] = <String>{}; // Initialize with an empty set
        filterProvider.selectedTaxonomies[i.slug!] = <Taxonomies>{}; // Initialize
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (context)=>FilterProvider(),
      child:Consumer<FilterProvider>(
        builder: (context,filterProvider,_){
          return Scaffold(
              appBar: AppBar(
                title: Text('Search Results'),
              ),
              body: Column(
                children: [
                  Wrap(
                    spacing: 8.0,
                    children: filterProvider.selectedOptions.entries
                        .map((entry) {
                      String section = entry.key;
                      Set<String> selectedOptions = entry.value;
                      List<Widget> chips = selectedOptions
                          .map((option) => Chip(
                        label: Text(option),
                        onDeleted: () {
                          filterProvider.selectOption(
                              section, option, Taxonomies()); // Replace Taxonomies() with your actual model
                        },
                      ))
                          .toList();
                      return chips;
                    })
                        .expand((chips) => chips)
                        .toList(),
                  ),
                  for (var entry in filteredDataMap.entries)
                    ExpansionTile(
                      title: buildExpansionTileTitle(
                          entry.key, entry.value,filterProvider), // Use the slug as the title
                      children: generateCheckboxList(
                          entry.key, entry.value, filterProvider),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      showToast(
                          "Total Taxonomies Count: ${filterProvider.calculateTotalTaxonomiesCount()}");
                    },
                    child: Text("Show Total Taxonomies Count"),
                  ),
                ],
              )
          );



          // for (var entry in filteredDataMap.entries)
          //   ExpansionTile(
          //     title: buildExpansionTileTitle(entry.key, entry.value), // Use the slug as the title
          //     children: generateCheckboxList(entry.key, entry.value),
          //   ),
          // Container(
          //     child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //       Text("Selected Options and Taxonomies:"),
          //       // Display selected options and taxonomies
          //       ...selectedOptions.entries.map((entry) {
          //         String section = entry.key;
          //         Set<String> selectedOptions = entry.value;
          //         Set<Taxonomies> selectedTaxonomies =
          //             this.selectedTaxonomies[section]!;
          //         List<String> taxonomyInfo = selectedTaxonomies
          //             .where((taxonomy) =>
          //                 selectedOptions.contains(taxonomy.slug))
          //             .map((taxonomy) =>
          //                 "${taxonomy.name} (${taxonomy.slug})")
          //             .toList();
          //
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //                 "$section Options: ${selectedOptions.join(', ')}"),
          //             Text(
          //                 "$section Taxonomies: ${taxonomyInfo.join(', ')} - ${selectedTaxonomies.length} items"),
          //           ],
          //         );
          //       }),
          //     ])),



        },
      ) ,
    );



  }


  // Widget buildExpansionTileTitle(String section, List<Taxonomies> taxonomies) {
  //   Set<Taxonomies> selectedTaxonomies = this.selectedTaxonomies[section]!;
  //   int selectedCount = selectedTaxonomies.length;
  //
  //   return ListTile(
  //     title: Text("$section - $selectedCount selected"),
  //   );
  // }
  //
  //
  // List<Widget> generateCheckboxList(
  //     String section, List<Taxonomies> taxonomies) {
  //   List<Widget> checkboxList = [];
  //
  //   for (Taxonomies taxonomy in taxonomies) {
  //     checkboxList.add(
  //       CheckboxListTile(
  //         title: Text(taxonomy.name.toString()),
  //         value: selectedOptions[section]?.contains(taxonomy.slug.toString()) ??
  //             false,
  //         onChanged: (bool? value) {
  //           setState(() {
  //             if (value!) {
  //               selectedOptions[section]!
  //                   .add(taxonomy.slug!); // Ensure taxonomy.slug is not null
  //               selectedTaxonomies[section]!.add(taxonomy);
  //             } else {
  //               selectedOptions[section]!
  //                   .remove(taxonomy.slug!); // Ensure taxonomy.slug is not null
  //               selectedTaxonomies[section]!.remove(taxonomy);
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   }
  //
  //   return checkboxList;
  // }
  //
  // // List<Widget> generateRadioList(String section,List<Taxonomies> taxonomies) {
  // //   List<Widget> radioList = [];
  // //
  // //   for (Taxonomies taxonomy in taxonomies) {
  // //     radioList.add(
  // //       RadioListTile<String>(
  // //         title: Text(taxonomy.name.toString()),
  // //         value: taxonomy.slug.toString(),
  // //         groupValue: selectedOptions[section],
  // //
  // //         onChanged: (String? value) {
  // //           setState(() {
  // //             selectedOptions[section] = value;
  // //
  // //             selectedTaxonomies[section] = taxonomies
  // //                 .firstWhere((element) => element.slug == value, orElse: () => Taxonomies());
  // //           });
  // //         },
  // //       ),
  // //     );
  // //   }
  // //
  // //   return radioList;
  // // }
  //
  // int calculateTotalTaxonomiesCount() {
  //   int totalTaxonomiesCount = 0;
  //   for (var entry in selectedTaxonomies.entries) {
  //     totalTaxonomiesCount += entry.value.length;
  //   }
  //   return totalTaxonomiesCount;
  // }
  //
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  Widget buildExpansionTileTitle(
      String section, List<Taxonomies> taxonomies, FilterProvider filterProvider) {
    Set<Taxonomies> selectedTaxonomies =
    filterProvider.selectedTaxonomies[section]!;
    int selectedCount = selectedTaxonomies.length;

    return ListTile(
      title: Text("$section - $selectedCount selected"),
    );
  }

  List<Widget> generateCheckboxList(String section, List<Taxonomies> taxonomies,
      FilterProvider filterProvider) {
    List<Widget> checkboxList = [];

    for (Taxonomies taxonomy in taxonomies) {
      checkboxList.add(
        CheckboxListTile(
          title: Text(taxonomy.name.toString()),
          value: filterProvider.selectedOptions[section]?.contains(taxonomy.slug.toString()) ??
              false,
          onChanged: (bool? value) {
            filterProvider.selectOption(
                section, taxonomy.slug.toString(), taxonomy);
          },
        ),
      );
    }

    return checkboxList;
  }
}
