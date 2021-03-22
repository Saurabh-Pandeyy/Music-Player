import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Widgets/CurrentTrack.dart';
import 'package:provider/provider.dart';



class PlayTrack extends StatefulWidget {

  final trackImageList;
  final trackNameList;
  final trackArtistList;
  final trackDurationList;
  final trackURLList;
  final trackIndex;

  PlayTrack({Key key,@required this.trackImageList,@required this.trackNameList,
  @required this.trackArtistList,@required this.trackDurationList,@required this.trackURLList, @required this.trackIndex}): super(key: key);
  
  @override 
  _PlayTrackState createState() => _PlayTrackState();
}

class _PlayTrackState extends State<PlayTrack> with TickerProviderStateMixin {
  
  PageController controller;

  AudioPlayer player = AudioPlayer();
  Duration trackDuration = Duration(seconds: 30);  //because we know its a preview url
  Duration currentPosition = Duration();
  int currentTrackIndex;
  AnimationController animationController;
  bool isOtherTrackPlaying;
  bool isCurrentTrackPlaying = true;
 
  
  @override
  void initState() {

    super.initState();
    controller = PageController(initialPage: widget.trackIndex);
    
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), 
      reverseDuration: Duration(milliseconds: 300),
    );
    currentTrackIndex = widget.trackIndex;
  } 
  
  Future playAudio() async{
    
    //to check if other track is already playing
    isOtherTrackPlaying = Provider.of<CurrentTrack>(context,listen: false).getIsSongPlaying();
    
    if(isOtherTrackPlaying){
      Provider.of<CurrentTrack>(context,listen: false).stopPlaying();
    }
    
    if(widget.trackURLList[currentTrackIndex] == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Container(child: Text('Can\'t play due to invalid url'),),),
      );
      controller.nextPage(duration: Duration(seconds: 2), curve: Curves.easeIn);
    }else{

      player.play(widget.trackURLList[currentTrackIndex]).then((value) => 
        Provider.of<CurrentTrack>(context,listen: false).setCurrentTrack(player,widget.trackImageList[currentTrackIndex],widget.trackNameList[currentTrackIndex],widget.trackArtistList[currentTrackIndex]));
      player.onPlayerError.listen((event) {
        print('error: $event');
      });
    }
  } 

  void playPauseButton(){
    
  }
  
  @override
  Widget build(BuildContext context) {
 
    playAudio(); 
  
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            
            PageView.builder(
              
              scrollDirection: Axis.vertical,
              controller: controller,
              
              itemCount: widget.trackNameList.length ,
              itemBuilder: (context,index){
                currentTrackIndex = index;
                try{
                  return Column( 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [

                      Padding( 
                        padding: EdgeInsets.all(8),
                        child: ClipRRect( 
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(widget.trackImageList[index],fit: BoxFit.contain,height: MediaQuery.of(context).size.height/2.9,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.trackNameList[index],
                          style: GoogleFonts.raleway(fontSize: 22,fontWeight: FontWeight.bold)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                        child: Text(widget.trackArtistList[index],style: GoogleFonts.raleway(fontSize: 18) ),
                      ),

                      //implement SB of durationstream to get total duration of track
                      StreamBuilder<Duration>(
                        stream: player.onAudioPositionChanged ,
                        builder: (context, snap) {

                          currentPosition = snap.data ?? Duration.zero;
                      
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                                child: Slider( 
                                  value: currentPosition.inSeconds.toDouble() ,
                                  max: trackDuration.inSeconds.toDouble(), 
                                  onChanged: (v){
                                    player.seek(Duration(seconds: v.toInt()));
                                  },
                                  activeColor: Colors.red,
                                  inactiveColor: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [ 
                                    Text(currentPosition.toString().split('.').first.substring(2)),
                                  
                                    Text(trackDuration.toString().split('.').first.substring(2))
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon :Icon(Icons.skip_previous_rounded),
                              onPressed:() => player.seek(currentPosition - Duration(seconds: 10) )
                            )
                          ),
                        
                          StreamBuilder<AudioPlayerState>(

                            stream: player.onPlayerStateChanged,
                            builder: (context, snapshot) {
                              
                              if(snapshot.data == AudioPlayerState.COMPLETED){
                                Provider.of<CurrentTrack>(context,listen: false).stopPlaying();
                                controller.nextPage(duration: Duration(seconds: 2), curve: Curves.easeIn);
                              }

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    
                                    InkWell(
                                      child: CircleAvatar(
                                        child: AnimatedIcon(
                                          icon: AnimatedIcons.pause_play,
                                          progress: animationController 
                                        ),
                                        radius: 30,
                                        backgroundColor: Colors.black, 
                                        foregroundColor: Colors.white,
                                      ),
                                      onTap:()async {
                                       if(snapshot.data == AudioPlayerState.PLAYING){
                                            await player.pause();
                                            animationController.forward();
                                          }
                                          if(snapshot.data == AudioPlayerState.PAUSED){
                                            await player.resume();
                                            animationController.reverse();
                                          }  
      
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          ), 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:IconButton(
                              icon:Icon(Icons.skip_next_rounded),
                              onPressed: () => player.seek(currentPosition + Duration(seconds: 10))
                            )
                        
                          ),
                        ])
                    
                    ],
                  );
                }catch(e){
                  print(e);
                  return Center(child: Text('No data'),);
                  
                }
                
              },
              onPageChanged: (v) => playAudio(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
                    
            Padding(
              padding: const EdgeInsets.all(25),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('Now Playing',style: GoogleFonts.roboto())),
            )
          ] 
        ),
      ),
    );
  }
}



