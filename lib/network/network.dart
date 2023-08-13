import 'package:eventsapp/model/classifications.dart';
import 'package:eventsapp/model/events.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Network {
  final apiurl = "https://app.ticketmaster.com";
  final apikey = "&apikey=cAGY2O0GBabKQo7jr6rxJ7WI6920I4rk";
  var endpoint = "/discovery/v2/events.json?";
  var nextpage = "/discovery/v2/events.json?";

  Future<List<Event>> loadMoreEvents({genreid = "", keyword = ""}) async {
    var classification = "";
    var searchkeyword = "";
    if (genreid != "" || keyword != "") {
      nextpage = endpoint;
      if (genreid != "0") {
        classification = "&classificationId=$genreid";
      }
      if (keyword != "") {
        searchkeyword = "&keyword=$keyword";
      }
    }

    if (nextpage == "") {
      // no more pages to load
      return [];
    }

    final url = apiurl + nextpage + apikey + classification + searchkeyword;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      nextpage = json?["_links"]?["next"]?["href"]?.toString() ?? "";

      if (json["_embedded"] != null) {
        return List<Event>.from(
            json["_embedded"]["events"].map((x) => Event.fromJson(x)));
      } else {
        return []; //no result
      }
    } else {
      throw Exception('Failed to load more events');
    }
  }

  Future<List<Classification>> loadClassifications() async {
    final url = "$apiurl/discovery/v2/classifications.json?$apikey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      json = json["_embedded"]["classifications"];

      List checkedjson = [];

      for (var js in json) {
        if (js["segment"] != null) {
          checkedjson.add(js["segment"]);
        }
      }
      return List<Classification>.from(
          checkedjson.map((x) => Classification.fromJson(x)));
    } else {
      throw Exception('Failed to load Classifications');
    }
  }
}
