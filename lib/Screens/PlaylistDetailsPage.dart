import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/PlayTrack.dart';
import 'package:music_player/Services/DataServices.dart';
import 'package:music_player/Widgets/SliverBar.dart';
import 'package:music_player/Widgets/WaitingWidget.dart';



class PlaylistDetailsPage extends StatefulWidget {

  final playlistId;
  final playlistImage;
  final playlistName;

  PlaylistDetailsPage({Key key,@required this.playlistId, @required this.playlistImage, @required this.playlistName}) : super(key: key);

  @override
  _PlaylistDetailsPageState createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
 
  var future;
  @override
  void initState() {
    super.initState();
    future =  DataServices().getPlaylistTracks(widget.playlistId); 
  }

  var data;

  List<Widget> trackData; 
  List trackImageList = [];
  List trackNameList = [];
  List trackArtistList = [];
  List trackDurationList = [];
  List trackURLList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return detailsPageWaitingWidget(context);
        }
        if(snapshot.data != null){
   
          data = jsonDecode(snapshot.data.body);
          
          try{
            trackData = List<Widget>.generate(
              data['items'].length, (index){   

                trackImageList.add(data['items'][index]['track']['album']['images'][0]['url']);
                trackNameList.add(data['items'][index]['track']['name']);
                trackArtistList.add(data['items'][index]['track']['artists'][0]['name']);
                trackDurationList.add(data['items'][index]['track']['duration_ms']);
                trackURLList.add(data['items'][index]['track']['preview_url']);
                
                return ListTile(  
                  leading: ClipRRect(  
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/Images/music.jpg',
                      image:  data['items'][index]['track']['album']['images'][0]['url'] 
                    )),

                  title: Text(data['items'][index]['track']['name'],style: GoogleFonts.raleway(fontWeight : FontWeight.bold),), 
                  subtitle: Text(data['items'][index]['track']['artists'][0]['name'],style: GoogleFonts.raleway()), 
                  
                  trailing: Text(Duration(milliseconds:data['items'][index]['track']['duration_ms']).toString().split('.').first.substring(2)),

                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder:(context) => PlayTrack (
                      trackNameList: trackNameList,
                      trackImageList: trackImageList,
                      trackArtistList: trackArtistList,
                      trackDurationList: trackDurationList,
                      trackURLList: trackURLList,
                      trackIndex: index,
                    )
                  )),
                );
              }
            );
          }catch(e){
            trackData = [Center(child: Text('No Data'),)];
          } 

        return SliverBar(
          backgroundImage: widget.playlistImage,
          appbarTitle: widget.playlistName,
          dataList: trackData,
        );
        }
       else return Container();
      }
      
    );
  }
}