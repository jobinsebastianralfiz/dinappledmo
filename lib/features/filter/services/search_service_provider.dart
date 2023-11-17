import 'package:flutter/material.dart';

import '../model/response_model.dart';

class FilterProvider extends ChangeNotifier {
  Map<String, Set<Taxonomies>> _selectedTaxonomies = {};
  Map<String, Set<String>> _selectedOptions = {};

  Map<String, Set<Taxonomies>> get selectedTaxonomies => _selectedTaxonomies;
  Map<String, Set<String>> get selectedOptions => _selectedOptions;

  void selectOption(String section, String option, Taxonomies taxonomy) {
    _selectedOptions.putIfAbsent(section, () => {});
    _selectedTaxonomies.putIfAbsent(section, () => {});

    if (_selectedOptions[section]!.contains(option)) {
      _selectedOptions[section]!.remove(option);
      _selectedTaxonomies[section]!.remove(taxonomy);
    } else {
      _selectedOptions[section]!.add(option);
      _selectedTaxonomies[section]!.add(taxonomy);
    }

    notifyListeners();
  }

  int calculateTotalTaxonomiesCount() {
    int totalTaxonomiesCount = 0;
    for (var entry in _selectedTaxonomies.entries) {
      totalTaxonomiesCount += entry.value.length;
    }
    return totalTaxonomiesCount;
  }
}
