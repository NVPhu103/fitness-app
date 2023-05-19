class Food {
  final String id;
  final String name;
  final int calories;
  final String unit;

  const Food(
      {required this.id,
      required this.name,
      required this.calories,
      required this.unit});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['id'],
        name: json['name'],
        calories: json['calories'],
        unit: json['unit']);
  }
}
