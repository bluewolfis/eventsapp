class Event {
  final String name;
  final String url;
  final List<dynamic> images;
  final Map<String, dynamic> dates;
  final List<dynamic> classifications;
  final String info;

  Event(
      {required this.name,
      required this.url,
      required this.images,
      required this.dates,
      required this.classifications,
      required this.info});

  factory Event.fromJson(json) => Event(
      name: json["name"],
      url: json["url"] ?? "",
      images: json["images"],
      dates: json["dates"],
      classifications: json["classifications"] ?? [],
      info: json["info"] ?? "");
}
