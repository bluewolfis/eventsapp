import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventsapp/model/events.dart';
import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final images = event.images;
    var imageurl = "http://via.placeholder.com/200x150";
    for (var image in images) {
      if (image["width"].toString() == "1136") {
        imageurl = image["url"].toString();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const SizedBox(height: 16),
            Row(
              children: [
                BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Text(event.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium),
                )
              ],
            ),
            const SizedBox(height: 16),
            CachedNetworkImage(
              height: 300,
              imageUrl: imageurl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                  child: event.info != ""
                      ? Text(event.info,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodySmall)
                      : Text(
                          "${event.dates["start"]["localDate"]} ${event.dates["start"]["localTime"]}",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.displayMedium)),
            )
          ]),
        ),
      ),
    );
  }
}
