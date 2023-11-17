import 'dart:convert';
import 'package:dineapple/features/filter/model/response_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class APIService with ChangeNotifier {
  ResponseModel? _cuisineData;
  List<Locations?> _locationsData = [];



  ResponseModel? get cuisineData => _cuisineData;
  List<Locations?> get locationData => _locationsData;

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/json/data.json');
  }

  Future<void> loadCuisines() async {
    try {
      String jsonData = await _loadAsset();
      final response = json.decode(jsonData);
      _cuisineData = ResponseModel.fromJson(response);
      //print(_cuisineData!.data!);
      // Notify listeners that the data has been loaded
      notifyListeners();
    } catch (e) {
      // Handle errors, log, or show an error message
      print('Error loading data: $e');
    }
  }

  Future<void> neighbourHoodData(String city) async {
    var neighbourhood = <Taxonomies>[];
    for (var data in cuisineData!.data!) {
      if (data.slug == "location" &&
          data.taxonomies != null &&
          data.taxonomies![0].city == city) {
        neighbourhood.addAll(data.taxonomies!);
        //print("hello");
      }
    }
    if (neighbourhood.isNotEmpty) {
      _locationsData = neighbourhood[0].locations!;
    }

    //print(_locationsData);
  }
}
