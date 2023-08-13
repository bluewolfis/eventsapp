import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventsapp/model/events.dart';
import 'package:eventsapp/ui/eventdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final images = event.images;
    var imageurl = "http://via.placeholder.com/200x150";
    for (var image in images) {
      if (image["height"].toString() == "225") {
        imageurl = image["url"].toString();
      }
    }

    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                width: 81,
                height: 81,
                imageUrl: imageurl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: SizedBox(
                      height: 81,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.name,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2),
                            const SizedBox(height: 4),
                            Row(children: [
                              Image.asset("assets/images/calendar.png"),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat.yMMMEd().format(DateTime.parse(event
                                    .dates["start"]["localDate"]
                                    .toString())),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                            ]),
                          ]))),
              const SizedBox(width: 16),
              Image.asset("assets/images/heart.png"),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetails(event: event)));
      },
    );
  }
}
