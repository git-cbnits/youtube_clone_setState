import 'package:flutter/material.dart';
import 'package:youtube_clone/screens/youtube/video_player_page.dart';

import '../../models/youtube/channel_info_model.dart';
import '../../services/youtube/services.dart';
import '../../models/youtube/video_list_model.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late ChannelInfo _channelInfo;
  late VideosList _videosList;
  late Item _item;
  bool isLoading = true;
  late String _playListId;
  String _nextPageToken = '';

  _getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    await _loadVideos();
    setState(() {
      isLoading = false;
    });
  }

  _loadVideos() async {
    VideosList tempVideosList = await Services.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    _videosList = tempVideosList;
    _nextPageToken = tempVideosList.nextPageToken;
  }

  @override
  void initState() {
    _getChannelInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My YouTube Channel'),
      ),
      body: isLoading?
      const Center(
        child: CircularProgressIndicator(),
      ):
      ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.network(_item.snippet.thumbnails.medium.url,height: 40,width: 40,),
                  const SizedBox(width: 20,),
                  Text(
                    _item.snippet.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _videosList.videos.isEmpty?
          Container(
            height: MediaQuery.of(context).size.height/1.5,
            alignment: Alignment.center,
            child: const Text('No Video Found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ):
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: _videosList.videos.length,
            itemBuilder: (context, index) {
              VideoItem videoItem = _videosList.videos[index];
              return InkWell(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return VideoPlayerScreen(
                          videoItem: videoItem,
                        );
                      }));
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(videoItem.video.thumbnails.thumbnailsDefault.url),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          videoItem.video.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
