// models.dart
class Filter {
  String name;
  String slug;
  List<Taxonomy> taxonomies;

  Filter({required this.name, required this.slug, required this.taxonomies});
}

class Taxonomy {
  int id;
  String guid;
  String slug;
  String name;
  List<String> selectedValues;

  Taxonomy({
    required this.id,
    required this.guid,
    required this.slug,
    required this.name,
    List<String>? selectedValues,
  }) : selectedValues = selectedValues ?? [];
}
