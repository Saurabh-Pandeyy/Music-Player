import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/PlayTrack.dart';
import 'package:music_player/Services/DataServices.dart';
import 'package:music_player/Widgets/SliverBar.dart';
import 'package:music_player/Widgets/WaitingWidget.dart';



class ArtistDetailsPage extends StatefulWidget {

  final artistId;
  final artistImage;
  final artistName;

  ArtistDetailsPage({Key key,@required this.artistId, @required this.artistImage, @required this.artistName}) : super(key: key);

  @override
  _ArtistDetailsPageState createState() => _ArtistDetailsPageState();
}

class _ArtistDetailsPageState extends State<ArtistDetailsPage> {

  var future;
 
  @override
  void initState() {
    super.initState();
    future = DataServices().getArtistTracks(widget.artistId);  
   
  }

  var data;
  List<Widget> trackData;
  List trackImageList = [];
  List trackNameList = [];
  List trackArtistList = [];
  List trackDurationList = [];
  List trackURLList = [];

  List subtitle = [];
  

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
            
            trackData = List<Widget>.generate(
              data['tracks'].length, (index){   
                
                for(int i = 0;i<data['tracks'][index]['artists'].length; i++){
                  subtitle.contains(data['tracks'][index]['artists'][i]['name']) ? print(subtitle) : subtitle.add(data['tracks'][index]['artists'][i]['name']);
                }

                trackImageList.add(data['tracks'][index]['album']['images'][0]['url']);
                trackNameList.add(data['tracks'][index]['name']);
                trackArtistList.add(subtitle.toString().split('[').last.split(']').first);
                trackDurationList.add(data['tracks'][index]['duration_ms']);
                trackURLList.add(data['tracks'][index]['preview_url']);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(  
                    leading: ClipRRect(  
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'lib/Images/music.jpg',
                        image:data['tracks'][index]['album']['images'][0]['url']
                      )),

                    title: Text(data['tracks'][index]['name'],style: GoogleFonts.raleway(fontWeight : FontWeight.bold),), 
                    subtitle: Text(subtitle.toString().split('[').last.split(']').first,style: GoogleFonts.raleway()), 
                    
                    trailing: Text(Duration(milliseconds:data['tracks'][index]['duration_ms']).toString().split('.').first.substring(2)),

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
                  ),
                ); 
              }
            );
          }catch(e){
            trackData = [Center(child: Text('No Data'),)];
          }

        return SliverBar(
          backgroundImage: widget.artistImage,
          appbarTitle: widget.artistName,
          dataList: trackData,
        );
        }

        else return Container();
        
      }
    );
  }
}