import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/PlayTrack.dart';
import 'package:music_player/Widgets/WaitingWidget.dart';

class CommonDetailPage extends StatefulWidget {

  final String spotifyId;
  final String spotifyImage;
  final String spotifyName;
  final trackList;
  final controller;

  CommonDetailPage({
    Key? key, required this.spotifyId, required this.spotifyImage,
    required this.spotifyName,  required this.trackList, required this.controller
  }) : super(key: key);

  @override
  _CommonDetailPageState createState() => _CommonDetailPageState();
}

class _CommonDetailPageState extends State<CommonDetailPage> with TickerProviderStateMixin {

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

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context,t){
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              floating: true, 
              snap: true,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height/3,
              
              flexibleSpace:LayoutBuilder(
                builder: (context,constraints){
                
                  var top = MediaQuery.of(context).padding.top + kToolbarHeight;
                    
                  return FlexibleSpaceBar(
                    background: Image.network(widget.spotifyImage,fit: BoxFit.cover,),
                    title: Text(constraints.biggest.height != top ? '' : widget.spotifyName,style: GoogleFonts.roboto())
                  );
                },
              ) 
              
            ),
          ];
        },
        body: Obx(
          (){

            if(widget.controller.isLoading.value){

              return detailsPageWaitingWidget();

            }else{
              return ListView.builder(

                scrollDirection: Axis.vertical,
                itemCount: widget.trackList.length,
                itemBuilder: (context,index){

                  String serialNo = (index + 1) < 10 ? '0${index + 1}' : (index + 1).toString();
                  
                  if(
                    widget.trackList[index].trackImage != null && widget.trackList[index].trackName != null &&
                    widget.trackList[index].trackSubtitle != null && widget.trackList[index].trackDuration != null
                  ){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          Text(serialNo,style: GoogleFonts.montserrat()),

                          Expanded(
                            child: ListTile(

                              leading: ClipRRect(  
                                borderRadius: BorderRadius.circular(5),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'lib/Images/music.jpg',
                                  image:  widget.trackList[index].trackImage
                                )),

                              title: Text(
                                widget.trackList[index].trackName, 
                                style: GoogleFonts.openSans(fontWeight : FontWeight.w600),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                              ),

                              subtitle: Text(
                                widget.trackList[index].trackSubtitle, 
                                style: GoogleFonts.montserrat()
                              ), 
                              
                              trailing: Text(
                                Duration(milliseconds: widget.trackList[index].trackDuration).toString().split('.').first.substring(2),
                                style: GoogleFonts.montserrat()
                              ),

                              onTap: () => Get.to(() => PlayTrack (

                                trackDataList: widget.trackList,
                                trackIndex: index,
                              ))
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else return Container();
                }
              );
            }
          }
        )
      ), 
      
      // bottomNavigationBar:currentTrackData[1] != null ? BottomAppBar(
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
      //               print(data.trackPlayer.state);
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
      //         );
      //     },
          
      //   )
           
      // )  : null
    );  
  } 
}











// bottomNavigationBar:currentTrackData[1] != null ? BottomAppBar(
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
      //               print(data.trackPlayer.state);
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
      //         );
      //     },
          
      //   )
           
      // )  : null