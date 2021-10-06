import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/ViewModels/PlayTrackViewModel.dart';

class PlayTrack extends StatefulWidget {

  final List trackDataList;
  final trackIndex;

  PlayTrack({Key? key,required this.trackDataList, required this.trackIndex}): super(key: key);
  
  @override 
  _PlayTrackState createState() => _PlayTrackState();
}

class _PlayTrackState extends State<PlayTrack> with TickerProviderStateMixin {
  
  late PageController pageController;
  late AnimationController animationController;
  late int currentTrackIndex;
  late bool isOtherTrackPlaying;

  AudioPlayer player = AudioPlayer();

  Duration trackDuration = Duration(seconds: 30);  //because we know its a preview url
  Duration currentPosition = Duration.zero;
  
  bool isCurrentTrackPlaying = true;

  List trackUrlList = [];
  late PlayTrackViewModel trackController;
 
  
  @override
  void initState() {

    trackController = Get.put(PlayTrackViewModel(),permanent: true);

    pageController = PageController(initialPage: widget.trackIndex);
    
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), 
      reverseDuration: Duration(milliseconds: 300),
    );

    currentTrackIndex = widget.trackIndex;
    trackUrlList = widget.trackDataList.map((e) => e.trackUrl!).toList(); // extracting url from trackDataList

    super.initState();
    
  } 
  
  Future playAudio() async{
    
    isOtherTrackPlaying = trackController.getIsSongPlaying();
    print(isOtherTrackPlaying);
    
    if(isOtherTrackPlaying){ 
      trackController.stopPlaying();
    }

    player.play(trackUrlList[currentTrackIndex]);

    trackController.setPlayerStateStream(player);
    trackController.setCurrentTrack(
      player,
      widget.trackDataList[currentTrackIndex].trackImage!,
      widget.trackDataList[currentTrackIndex].trackName!,
      widget.trackDataList[currentTrackIndex].trackSubtitle!
    );

    player.onPlayerError.listen((event) {
      print('error: $event');
    });
  } 

  
  @override
  Widget build(BuildContext context) {
    print('build');

    playAudio();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            
            PageView.builder(
              
              scrollDirection: Axis.vertical,
              controller: pageController,
              
              itemCount: widget.trackDataList.length,
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

                          child: Image.network(
                            widget.trackDataList[index].trackImage!,
                            fit: BoxFit.contain,
                            height: Get.size.height/2.9,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.trackDataList[index].trackName!,
                          style: GoogleFonts.raleway(
                            fontSize: 22, fontWeight: FontWeight.bold
                          )
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                        child: Text(
                          widget.trackDataList[index].trackSubtitle!,
                          style: GoogleFonts.raleway(fontSize: 18) 
                        ),
                      ),

                      Obx(       //streaming current position of player
                        (){

                          currentPosition = trackController.durationStream.value;

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

                          Obx(      //streaming audio player state 
                            (){

                              if( trackController.playerStateStream.value == AudioPlayerState.COMPLETED ){

                                trackController.stopPlaying();
                                pageController.nextPage(duration: Duration(seconds: 2), curve: Curves.easeIn);
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

                                        if( trackController.playerStateStream.value == AudioPlayerState.PLAYING ){
                                          await player.pause();
                                          animationController.forward();
                                        }
                                        if(trackController.playerStateStream.value == AudioPlayerState.PAUSED){
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
                        ]
                      )
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