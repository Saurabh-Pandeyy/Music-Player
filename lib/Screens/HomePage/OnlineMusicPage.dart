import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/DetailScreens/CommonDetailPage.dart';
import 'package:music_player/ViewModels/DetailPageViewModel.dart';
import 'package:music_player/ViewModels/OnlineMusicViewModel.dart';
import 'package:music_player/Widgets/WaitingWidget.dart';

class OnlineMusicPage extends StatefulWidget {

  @override
  _OnlineMusicPageState createState() => _OnlineMusicPageState();
}

class _OnlineMusicPageState extends State<OnlineMusicPage> with TickerProviderStateMixin {

  late AnimationController imageController;
  late AnimationController iconController;

  @override
  void initState() {

    imageController = AnimationController(vsync: this, duration: Duration(seconds: 5))..forward(from:0.0)..repeat();
    iconController = AnimationController(vsync: this, duration: Duration(milliseconds: 300),reverseDuration: Duration(milliseconds: 300));
    super.initState();
  
  }

  @override
  void dispose() {
    
    imageController.dispose();
    super.dispose();
  }

  OnlineMusicViewModel controller = Get.put(OnlineMusicViewModel());
  DetailPageViewModel trackController = Get.put(DetailPageViewModel());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [

            titleWidget('Indian Featured Playlists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: spotifyCard(controller.indianPlaylists,'lib/Images/album.jpg', 'IndianPlaylist',)
            ),

            titleWidget('Popular Podcasts'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: spotifyCard(controller.podcasts,'lib/Images/album.jpg', 'Podcast',)
            ),

            titleWidget('International Featured Playlists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: spotifyCard(controller.internationalPlaylists,'lib/Images/album.jpg', 'InternationalPlaylist',)
            ),

            titleWidget('New Releases'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: spotifyCard(controller.newReleases, 'lib/Images/music.jpg', 'NewReleases',)
            ),

            titleWidget('Artists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: spotifyCard(controller.artists, 'lib/Images/artist.png', 'Artists',)
            ),

             titleWidget('My Playlists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: spotifyCard(controller.myPlaylists, 'lib/Images/album.jpg', 'MyPlaylist',)
            ),
          ],
        ),
      ),

      //  bottomNavigationBar: currentTrackData[1] != null ? BottomAppBar(
      //   child: Consumer<CurrentTrack>(
      //     builder: (context,data,child){

      //       bool isPlaying = data.isSongPlaying;

      //       data.trackPlayer.onPlayerCompletion.listen((event) {
      //         iconController.forward();
      //         imageController.reset();
      //         isPlaying = false;
      //       });
            
      //       return Container(
      //           color:Colors.black,
      //           child: ListTile( 
      //           contentPadding: EdgeInsets.all(3),
      //           leading: isPlaying ? RotationTransition( 
      //             turns: Tween(begin: 0.0, end: 1.0).animate(imageController),
      //             child: CircleAvatar(
      //               radius:25,  
      //               backgroundImage: NetworkImage(data.image, )
      //             ),
      //           ) : CircleAvatar(
      //               radius:25, 
      //               backgroundImage: NetworkImage(data.image )  
      //             ),
      //           title: Text(data.trackName,style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),  
      //           subtitle: Text(data.trackSubtitle,style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),
      //           trailing: IconButton(
      //             icon: AnimatedIcon(
      //               color: Colors.white,
      //               icon: AnimatedIcons.pause_play,
      //               progress: iconController,
      //             ),
      //             onPressed: ()async{

      //               if(isPlaying){
      //                 await data.trackPlayer.pause(); 
      //                 iconController.forward();
                      
      //               }
      //               if(!isPlaying){
      //                 await data.trackPlayer.resume();
      //                 iconController.reverse();
                      
      //               }
      //               isPlaying = !isPlaying;
                   
      //             },
      //           )

      //       ),
      //       );
      //     },
      //   )
      // )  : null
    );
  }

  Widget titleWidget(String text){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(text,  
        style: GoogleFonts.roboto(fontSize: 22,fontWeight: FontWeight.bold,),
      ),),
    );
  }

  Widget spotifyCard(var spotifyData, String placeholderImage, String type,){

    return Obx(
      (){

        if(controller.isLoading.value){

          return homePageWaitingWidget();

        } else{

          return spotifyData.isNotEmpty ? ListView.builder(
            itemCount: spotifyData.length,
            scrollDirection: Axis.horizontal,  
            itemBuilder: (context,index){ 
              
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(

                  onTap: () {

                    if(type == 'IndianPlaylist'){

                      trackController.indianTracks(spotifyData[index].spotifyId);

                      Get.to(() => CommonDetailPage(
                        spotifyId: spotifyData[index].spotifyId, 
                        spotifyImage: spotifyData[index].spotifyImage,
                        spotifyName: spotifyData[index].spotifyName, 
                        trackList: trackController.indianPlaylistTracks, 
                        controller: trackController
                      ));
                    }

                     if(type == 'InternationalPlaylist'){

                      trackController.internationalTracks(spotifyData[index].spotifyId);

                      Get.to(() => CommonDetailPage(
                        spotifyId: spotifyData[index].spotifyId, 
                        spotifyImage: spotifyData[index].spotifyImage,
                        spotifyName: spotifyData[index].spotifyName, 
                        trackList: trackController.internationalPlaylistsTracks, 
                        controller: trackController
                      ));
                    }

                     if(type == 'MyPlaylist'){

                      trackController.myTracks(spotifyData[index].spotifyId);

                      Get.to(() => CommonDetailPage(
                        spotifyId: spotifyData[index].spotifyId, 
                        spotifyImage: spotifyData[index].spotifyImage,
                        spotifyName: spotifyData[index].spotifyName, 
                        trackList: trackController.myPlaylistsTracks, 
                        controller: trackController
                      ));
                    }

                     if(type == 'Podcast'){

                      trackController.popularPodcastTracks(spotifyData[index].spotifyId);

                      Get.to(() => CommonDetailPage(
                        spotifyId: spotifyData[index].spotifyId, 
                        spotifyImage: spotifyData[index].spotifyImage,
                        spotifyName: spotifyData[index].spotifyName, 
                        trackList: trackController.podcastsTracks, 
                        controller: trackController
                      ));
                    }

                     if(type == 'NewReleases'){

                      trackController.newReleasesTracksList(spotifyData[index].spotifyId, spotifyData[index].spotifyImage);

                      Get.to(() => CommonDetailPage(
                        spotifyId: spotifyData[index].spotifyId, 
                        spotifyImage: spotifyData[index].spotifyImage,
                        spotifyName: spotifyData[index].spotifyName, 
                        trackList: trackController.newReleasesTracks, 
                        controller: trackController
                      ));
                    }

                     if(type == 'Artists'){

                      trackController.artistsList(spotifyData[index].spotifyId);

                      Get.to(() => CommonDetailPage(
                        spotifyId: spotifyData[index].spotifyId, 
                        spotifyImage: spotifyData[index].spotifyImage,
                        spotifyName: spotifyData[index].spotifyName, 
                        trackList: trackController.artistsTracks, 
                        controller: trackController
                      ));
                    }
                  },

                  child: Container(
                    height:250,
                    child: Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            FadeInImage.assetNetwork(
                              placeholder: placeholderImage ,
                              image: spotifyData[index].spotifyImage,
                              height: 150,width: 135,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                spotifyData[index].spotifyName,overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(fontWeight: FontWeight.w600), 
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ) 
              );
            }
          ) : type == 'MyPlaylist' ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Card( 
                elevation: 7,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: 150,
                  alignment: Alignment.center,
                  child: Text('No Playlist',style: GoogleFonts.roboto(fontWeight: FontWeight.w600))
                )
              ), 
            ),
          ) : homePageWaitingWidget();
        }  
      }
    ); 
  }
}