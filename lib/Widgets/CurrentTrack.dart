import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class CurrentTrack extends ChangeNotifier {

  bool isSongPlaying = false;
  AudioPlayer trackPlayer;
  String image;
  String trackName;
  String trackSubtitle;

  void setCurrentTrack(AudioPlayer player, String imageUrl, String title,String subtitle)async{
    
    trackPlayer = player;
    isSongPlaying = true;
    image = imageUrl;
    trackName = title;
    trackSubtitle = subtitle;
    notifyListeners();
  }

  
  void stopPlaying(){
 
    trackPlayer.stop();
    isSongPlaying = false;
  }

  bool getIsSongPlaying(){
    return isSongPlaying;
  }
  
   List getCurrentTrackDetails(){
     return [trackPlayer,image,trackName,trackSubtitle,isSongPlaying];
   }
}