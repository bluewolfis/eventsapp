import 'package:eventsapp/model/classifications.dart';
import 'package:eventsapp/model/events.dart';
import 'package:eventsapp/network/network.dart';
import 'package:eventsapp/ui/widgets/noresultwidget.dart';
import 'package:eventsapp/ui/widgets/eventwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListEvents extends StatefulWidget {
  const ListEvents({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListEventsState();
  }
}

class ListEventsState extends State {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late Future<List<Event>> futureEvents;
  late Future<List<Classification>> futureClassifications;

  final network = Network();

  List<Event> listofEvents = [];
  List<Classification> listofClassifications = [];

  var isloading = false;
  var menuopen = false;
  var closebtn = false;
  var noresults = false;
  var selectedgenre = "All Genres";
  var selectedgenreId = "0";

  @override
  void initState() {
    super.initState();

    loadMoreEvents();

    futureClassifications = network.loadClassifications();
    futureClassifications.then((classifications) {
      listofClassifications
          .add(Classification(name: selectedgenre, id: "0", ischecked: true));
      listofClassifications.addAll(classifications);

      listofClassifications
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Stack(children: [
          Column(
            children: [
              Row(
                children: [
                  Text("Events",
                      style: Theme.of(context).textTheme.displayLarge)
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        doSearch();
                      },
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        hintText: 'Search...',
                        prefixIcon: IconButton(
                          icon: Image.asset("assets/images/search.png"),
                          onPressed: () {
                            //
                          },
                        ),
                        suffixIcon: SizedBox(
                          width: 200,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                closebtn
                                    ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          doSearch();
                                        },
                                        icon: Image.asset(
                                            "assets/images/clear.png",
                                            width: 20.0,
                                            height: 20.0))
                                    : const SizedBox(width: 0),
                                GestureDetector(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 1.0,
                                          height: 24.0,
                                          color: const Color(0xffC5C6D3),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          selectedgenre,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        RotatedBox(
                                          quarterTurns: menuopen ? 2 : 0,
                                          child: Image.asset(
                                            "assets/images/icdown.png",
                                            width: 20.0,
                                            height: 20.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => handleMenu(),
                                ),
                              ]),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              Expanded(
                child: Column(children: [
                  Flexible(
                    child: NotificationListener(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (_scrollController.position.userScrollDirection ==
                            ScrollDirection.reverse) {
                          if (scrollInfo is ScrollEndNotification) {
                            loadMoreEvents();
                          }
                        }
                        return false;
                      },
                      child: Stack(children: [
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: listofEvents.length,
                          itemBuilder: (context, index) {
                            return EventWidget(event: listofEvents[index]);
                          },
                        ),
                        isloading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox(width: 0, height: 0),
                        noresults
                            ? const NoResult()
                            : const SizedBox(width: 0, height: 0)
                      ]),
                    ),
                  )
                ]),
              )
            ],
          ),
          menuopen
              ? Positioned(
                  right: 0,
                  top: 128,
                  child: SizedBox(
                    width: 226,
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                  child: Text(
                                    "FILTER BY GENRE",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: listofClassifications.length,
                                  itemBuilder: (context, index) {
                                    return Row(children: [
                                      Checkbox(
                                        shape: const CircleBorder(),
                                        value: listofClassifications[index]
                                            .ischecked,
                                        onChanged: (value) {
                                          if (!isloading) {
                                            setGenreTo(index);
                                          }
                                        },
                                      ),
                                      GestureDetector(
                                        child: Text(
                                            listofClassifications[index].name),
                                        onTap: () {
                                          if (!isloading) {
                                            setGenreTo(index);
                                          }
                                        },
                                      ),
                                    ]);
                                  },
                                )
                              ])),
                    ),
                  ),
                )
              : const SizedBox(width: 0, height: 0)
        ]),
      )),
    );
  }

  loadMoreEvents({reset = false, keyword = ""}) {
    if (!isloading) {
      setState(() {
        isloading = true;
      });
      if (reset) {
        if (_searchController.text != "") {
          closebtn = true;
        }
        listofEvents = [];
        futureEvents = network.loadMoreEvents(
            genreid: selectedgenreId, keyword: _searchController.text);
      } else {
        futureEvents = network.loadMoreEvents();
      }
      futureEvents.then((events) {
        setState(() {
          listofEvents.addAll(events);
          isloading = false;
          noresults = false;
          if (listofEvents.isEmpty) {
            noresults = true;
          }
        });
      });
    }
  }

  setGenreTo(int index) {
    for (var genre in listofClassifications) {
      setState(() {
        if (genre == listofClassifications[index]) {
          genre.ischecked = true;
          selectedgenre = genre.name;
          selectedgenreId = genre.id;
        } else {
          genre.ischecked = false;
        }
      });
    }
    handleMenu();
    loadMoreEvents(reset: true);
  }

  doSearch() {
    setState(() {
      menuopen = false;
      loadMoreEvents(reset: true);
      if (_searchController.text == "") {
        closebtn = false;
      }
    });
  }

  handleMenu() {
    setState(() {
      menuopen = !menuopen;
    });
  }
}
