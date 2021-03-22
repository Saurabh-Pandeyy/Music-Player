import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/PlayTrack.dart';
import 'package:music_player/Services/DataServices.dart';
import 'package:music_player/Widgets/SliverBar.dart';
import 'package:music_player/Widgets/WaitingWidget.dart';


class NewReleasesDetailsPage extends StatefulWidget {

  final albumId;
  final albumImage;
  final albumName;

  NewReleasesDetailsPage({Key key,@required this.albumId, @required this.albumImage, @required this.albumName}) : super(key: key);

  @override
  _NewReleasesDetailsPageState createState() => _NewReleasesDetailsPageState();
}

class _NewReleasesDetailsPageState extends State<NewReleasesDetailsPage> {
 
  var future;

  @override
  void initState() {
    super.initState();
    future = DataServices().getNewReleasesTracks(widget.albumId);
  }

  var data;

  List<Widget> trackData; 

  List albumImageList = [];
  List albumNameList = [];
  List albumArtistList = [];
  List albumDurationList = [];
  List albumURLList = [];
  List subtitle = [];

  Future getData()async{ 

      
  }

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
          trackData = List<Widget>.generate(data['items'].length, (index){   

            for(int i = 0;i<data['items'][index]['artists'].length; i++){
              
              subtitle.contains(data['items'][index]['artists'][i]['name']) ? print('hello') : subtitle.add(data['items'][index]['artists'][i]['name']);
              
            }

            albumImageList.add(widget.albumImage);
          
            albumNameList.add(data['items'][index]['name']);
            albumArtistList.add(subtitle.toString().split('[').last.split(']').first);
            albumDurationList.add(data['items'][index]['duration_ms']);
            albumURLList.add(data['items'][index]['preview_url']);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(  
                leading: ClipRRect(  
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'lib/Images/music.jpg',
                    image: widget.albumImage
                  )),

                title: Text(data['items'][index]['name'],style: GoogleFonts.raleway(fontWeight : FontWeight.bold),), 
                subtitle: Text(subtitle.toString().split('[').last.split(']').first,style: GoogleFonts.raleway()), 
                
                trailing: Text(Duration(milliseconds:data['items'][index]['duration_ms']).toString().split('.').first.substring(2)),

                onTap: () => Navigator.push(
                  context, MaterialPageRoute(
                  builder:(context) => PlayTrack (
                    trackNameList: albumNameList,
                    trackImageList: albumImageList,
                    trackArtistList: albumArtistList,
                    trackDurationList: albumDurationList,
                    trackURLList: albumURLList,
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
            backgroundImage: widget.albumImage,
            appbarTitle: widget.albumName,
            dataList: trackData,
          );
        } 
        else return Container();
      }
    );
  } 
}