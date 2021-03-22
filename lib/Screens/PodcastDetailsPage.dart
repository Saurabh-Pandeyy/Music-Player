import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/PlayTrack.dart';
import 'package:music_player/Services/DataServices.dart';
import 'package:music_player/Widgets/SliverBar.dart';
import 'package:music_player/Widgets/WaitingWidget.dart';


class PodcastDetailsPage extends StatefulWidget {

  final podcastId;
  final podcastImage;
  final podcastName;

  PodcastDetailsPage({Key key,@required this.podcastId, @required this.podcastImage, @required this.podcastName}) : super(key: key);

  @override
  _PodcastDetailsPageState createState() => _PodcastDetailsPageState();
}

class _PodcastDetailsPageState extends State<PodcastDetailsPage> {
 
  var future;

  @override
  void initState() {
    super.initState();
    future = DataServices().getPodcastEpisodes(widget.podcastId);
   
  }

  var data;
  List<Widget> podcastData; 
  List podcastImageList = [];
  List podcastNameList = [];
  List podcastArtistList = [];
  List podcastDurationList = [];
  List podcastURLList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return detailsPageWaitingWidget(context);
        }

        if(snapshot.data != null){
          
      
          try{
            data = jsonDecode(snapshot.data.body);
            podcastData = List<Widget>.generate(data['items'].length, (index){   

              podcastImageList.add(data['items'][index]['images'][0]['url']);
              podcastNameList.add(data['items'][index]['name']);
              podcastArtistList.add(data['items'][index]['release_date']); 
              podcastDurationList.add(data['items'][index]['duration_ms']);
              podcastURLList.add(data['items'][index]['audio_preview_url']);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(  
                  leading: ClipRRect(  
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/Images/music.jpg',
                      image:data['items'][index]['images'][0]['url'] 
                    )),

                  title: Text(data['items'][index]['name'],style: GoogleFonts.raleway(fontWeight : FontWeight.bold),), 
                  subtitle: Text(data['items'][index]['release_date']), 
                  
                  trailing: Text(Duration(milliseconds:data['items'][index]['duration_ms']).toString().split('.').first.substring(2)),

                  onTap: () => Navigator. push(context, MaterialPageRoute(
                    builder:(context) => PlayTrack (
                      trackNameList: podcastNameList,
                      trackImageList: podcastImageList,
                      trackArtistList: podcastArtistList,
                      trackDurationList: podcastDurationList,
                      trackURLList: podcastURLList,
                      trackIndex: index,
                    )
                  )),
                ),
              );
            }
            );
          }catch(e){
            podcastData = [Center(child: Text('No Data'),)];
          }

          return SliverBar(
            backgroundImage: widget.podcastImage,
            appbarTitle: widget.podcastName,
            dataList: podcastData,
          );
        }
        else return Container();
      }
    );
  }
}