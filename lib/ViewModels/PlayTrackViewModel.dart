import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class PlayTrackViewModel extends GetxController {

  bool isSongPlaying = true;
  AudioPlayer? trackPlayer;
  String? image;
  String? trackName;
  String? trackSubtitle;

  var durationStream = Duration.zero.obs;
  var playerStateStream =  AudioPlayerState.STOPPED.obs;

  

  setPlayerStateStream(AudioPlayer player) {

    durationStream.value = Duration.zero;

    durationStream.bindStream(player.onAudioPositionChanged);

    playerStateStream.bindStream(player.onPlayerStateChanged);
  }

  void setCurrentTrack(AudioPlayer player, String imageUrl, String title,String subtitle)async{
    
    trackPlayer = player;
    isSongPlaying = true;
    image = imageUrl;
    trackName = title;
    trackSubtitle = subtitle;
    update();
  }

  
  void stopPlaying(){
    
    if(trackPlayer != null){

      trackPlayer!.stop();
      isSongPlaying = false;
      print('stop');
      print(getIsSongPlaying);
      update();
    }
  }

  bool getIsSongPlaying(){
    return isSongPlaying;
  }
  
  List getCurrentTrackDetails(){
    return [trackPlayer,image,trackName,trackSubtitle,isSongPlaying];
  }
}