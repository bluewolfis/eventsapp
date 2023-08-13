class Classification {
  final String name;
  final String id;
  bool ischecked;

  Classification({
    required this.name,
    required this.id,
    required this.ischecked,
  });

  factory Classification.fromJson(json) => Classification(
        name: json["name"],
        id: json["id"],
        ischecked: false,
      );
}
