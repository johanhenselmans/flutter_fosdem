import 'package:flutter/material.dart';
import 'package:fosdem/data/database_helper.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

/// Displays a list of Tracks.
class TrackList extends StatefulWidget with ChangeNotifier {
  final SettingsController settingsController;

  TrackList({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  static const routeName = '/tracklist';

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<String>? trackList = [];


  @override
  void initState() {
    super.initState();
    widget.settingsController.addListener(_handleSettingsChanged);
  }


  @override
  void dispose() {
    widget.settingsController.removeListener(_handleSettingsChanged);
    //widget.controller.removeListener(_handleFosdemChanged);
    super.dispose();
  }

  void _handleSettingsChanged() {
    setState(() {});
  }


  Future<List<String>> getTrackList() async {
    List<String> trackList = await databaseHelper.getTrackListFromDb(
        int.parse(widget.settingsController.fosdemSelectedYear), widget.settingsController);
    return trackList;
  }

// To work with lists that may contain a large number of items, it’s best
// to use the ListView.builder constructor.
//
// In contrast to the default ListView constructor, which requires
// building all Widgets up front, the ListView.builder constructor lazily
// builds Widgets as they’re scrolled into view.

  Widget showSearchableList(trackList) {
    return SearchableList<String>(
      builder: (String anTrack) => TrackItem(settingsController: widget.settingsController,track: anTrack),
      loadingWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text('Loading tracks...')
        ],
      ),
      asyncListCallback: () async {
        await Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );
        return trackList;
      },
      asyncListFilter: (q, aList) {
        return aList.where((element) => element.contains(q)).toList();
      },
//      filter: (value) => trackList
//          .swhere(
//            (element) => element.title.toLowerCase().contains(value),
//          )
//          .toList(),
      onItemSelected: (String item) {},
      emptyWidget: const EmptyView(),

      inputDecoration: InputDecoration(
        labelText: "Search Tracks",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<String>>(
          future: getTrackList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              trackList = snapshot.data;
              return showSearchableList(trackList!);
            } else {
              return Column(children: const <Widget>[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ]);
            }
          }),
    );
  }
}

class TrackItem extends StatelessWidget {
  final String track;
  final SettingsController settingsController;

  const TrackItem({
    Key? key,
    required this.track,
    required this.settingsController,
  }) : super(key: key);

  goHome(BuildContext context) {
    GoRouter.of(context).pushReplacement('/');
  }

  goToEventTrack(context, String track) {
    settingsController.updateSelectedTrack(track);
    GoRouter.of(context).push('/eventlist');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleGestureDetector(
        onTap: () {
          goToEventTrack(context, track);
        },
        swipeConfig: const SimpleSwipeConfig(
          verticalThreshold: 40.0,
          horizontalThreshold: 40.0,
          swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
        ),
        child: Container(
          //height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      track,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no track is found with this title'),
      ],
    );
  }
}
