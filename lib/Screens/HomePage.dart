import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/NewReleasesDetailsPage.dart';
import 'package:music_player/Screens/ArtistDetailsPage.dart';
import 'package:music_player/Screens/PlaylistDetailsPage.dart';
import 'package:music_player/Screens/PodcastDetailsPage.dart';
import 'package:music_player/Services/DataServices.dart';
import 'package:music_player/Widgets/CurrentTrack.dart';
import 'package:music_player/Widgets/WaitingWidget.dart'; 
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  AnimationController imageController;
  AnimationController iconController;

  var featuredPlaylistFuture;
  var popularPodcastFuture;
  var newReleasesFuture;
  var artistsFuture;
  var myPlaylistFuture;

  @override
  void initState() {
    super.initState();

    featuredPlaylistFuture = DataServices().getFeaturedPlaylists();
    popularPodcastFuture = DataServices().getPopularPodcastsData();
    newReleasesFuture = DataServices().getNewReleasesData();
    artistsFuture = DataServices().getArtists();
    myPlaylistFuture = DataServices().getMyPlayListData();

    imageController = AnimationController(vsync: this, duration: Duration(seconds: 5))..forward(from:0.0)..repeat();
    iconController = AnimationController(vsync: this, duration: Duration(milliseconds: 300),reverseDuration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    imageController.dispose();
    
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    List currentTrackData = Provider.of<CurrentTrack>(context).getCurrentTrackDetails();
    return Scaffold(
      appBar: AppBar(
         
        backgroundColor: Colors.black,
        title: Text('Music Player',style: GoogleFonts.croissantOne()),    
        actions: [
          CircleAvatar(
            radius: 20,
          child: Image.asset('lib/Images/avatar.png'),
        ),
        ] 
      ),
      body: SafeArea(
        child: ListView(
          children: [

            titleWidget('Featured Playlists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: playlistCard('Featured Playlist')
            ),

            titleWidget('Popular Podcasts'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: popularPodCastsCard()
            ),

            titleWidget('New Releases'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: newReleasesCard()
            ),

            titleWidget('Artists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: artistsCard()
            ),

             titleWidget('My Playlists'),

            Container(
              height: MediaQuery.of(context).size.height/4,
              child: playlistCard('My Playlist')
            ),
          ],
        ),
      ),

      bottomNavigationBar: currentTrackData[1] != null ? BottomAppBar(
        child: Consumer<CurrentTrack>(
          builder: (context,data,child){

            bool isPlaying = data.isSongPlaying;

            data.trackPlayer.onPlayerCompletion.listen((event) {
              iconController.forward();
              imageController.reset();
              isPlaying = false;
            });
            
            return Container(
                color:Colors.black,
                child: ListTile( 
                contentPadding: EdgeInsets.all(3),
                leading: isPlaying ? RotationTransition( 
                  turns: Tween(begin: 0.0, end: 1.0).animate(imageController),
                  child: CircleAvatar(
                    radius:25,  
                    backgroundImage: NetworkImage(data.image, )
                  ),
                ) : CircleAvatar(
                    radius:25, 
                    backgroundImage: NetworkImage(data.image )  
                  ),
                title: Text(data.trackName,style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),  
                subtitle: Text(data.trackSubtitle,style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),
                trailing: IconButton(
                  icon: AnimatedIcon(
                    color: Colors.white,
                    icon: AnimatedIcons.pause_play,
                    progress: iconController,
                  ),
                  onPressed: ()async{

                    if(isPlaying){
                      await data.trackPlayer.pause(); 
                      iconController.forward();
                      
                    }
                    if(!isPlaying){
                      await data.trackPlayer.resume();
                      iconController.reverse();
                      
                    }
                    isPlaying = !isPlaying;
                   
                  },
                )

            ),
            );
          },
        )
      )  : null
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

  Widget playlistCard(String code){

    return FutureBuilder(

      future: code == 'My Playlist' ? myPlaylistFuture : featuredPlaylistFuture, 
      builder: (context,snap){

        if(snap.connectionState == ConnectionState.waiting){
          return homePageWaitingWidget();
        }
        if(snap.data != null){
          
          var data = code == 'My Playlist' ? jsonDecode(snap.data.body) : jsonDecode(snap.data.body)['playlists'];
          
          return data['items'].length > 0 ? ListView.builder(
            itemCount: data['items'].length,
            scrollDirection: Axis.horizontal,  
            itemBuilder: (context,index){  
              
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder:(context) => PlaylistDetailsPage(
                        playlistId: data['items'][index]['id'],
                        playlistImage: data['items'][index]['images'][0]['url'],
                        playlistName: data['items'][index]['name'],
                      )
                    )), 
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(13),topRight:Radius.circular(13)),
                            child: FadeInImage.assetNetwork(
                              placeholder:'lib/Images/album.jpg' ,
                              image: data['items'][index]['images'][0]['url'],
                              height: 150,width: 150,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['items'][index]['name'],overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.raleway(fontWeight: FontWeight.w600), 
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ) 
              );
            }) : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Card( 
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    child: Container(
                      width: 150,
                      alignment: Alignment.center,
                      child: Text('No Playlist',style: GoogleFonts.raleway(fontWeight: FontWeight.w600), ))), 
              ),
            );
        } 
        else return Container(); 
      }
    ); 
  }

  Widget popularPodCastsCard(){

    return FutureBuilder(

      future: popularPodcastFuture, 
      builder: (context,snap){

        if(snap.connectionState == ConnectionState.waiting){
          return homePageWaitingWidget();
        }
        if(snap.data != null){

          var data = jsonDecode(snap.data.body);

          return ListView.builder(
            itemCount: data['shows'].length,
            scrollDirection: Axis.horizontal, 
            itemBuilder: (context,index){

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder:(context) => PodcastDetailsPage(
                          podcastId: data['shows'][index]['id'],
                          podcastImage: data['shows'][index]['images'][0]['url'],
                          podcastName: data['shows'][index]['name'],
                        )
                      )),
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(13),topRight:Radius.circular(13)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/Images/album.jpg',
                              image: data['shows'][index]['images'][0]['url'], 
                              height: 150,width: 150,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['shows'][index]['name'],overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }); 
        } 
        else return Container(); 
      }
    ); 
  }

  Widget newReleasesCard(){

    return FutureBuilder(

      future: newReleasesFuture, 
      builder: (context,snap){

        if(snap.connectionState == ConnectionState.waiting){
          return homePageWaitingWidget();
        }
        if(snap.data != null){

          var data = jsonDecode(snap.data.body);

          return ListView.builder(
            itemCount: data['albums']['items'].length,
            scrollDirection: Axis.horizontal, 
            itemBuilder: (context,index){

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder:(context) => NewReleasesDetailsPage(
                          albumId: data['albums']['items'][index]['id'],
                          albumImage: data['albums']['items'][index]['images'][0]['url'],
                          albumName: data['albums']['items'][index]['name'],
                        )
                      )),
                    child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(13),topRight:Radius.circular(13)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/Images/music.jpg',
                              image:data['albums']['items'][index]['images'][0]['url'],
                              height: 150,width: 150,
                            ),
                          ), 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['albums']['items'][index]['name'],overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                 
              );
            }); 
        } 
        else return Container(); 
      }
    ); 
  }

  Widget artistsCard(){

    return FutureBuilder(

      future: artistsFuture, 
      builder: (context,snap){

        if(snap.connectionState == ConnectionState.waiting){
          return homePageWaitingWidget();
        }
        if(snap.data != null){

          var data = jsonDecode(snap.data.body);
          
          return ListView.builder(
            itemCount: data['artists'].length,
            scrollDirection: Axis.horizontal, 
            itemBuilder: (context,index){

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder:(context) => ArtistDetailsPage(
                      artistId: data['artists'][index]['id'],
                      artistImage: data['artists'][index]['images'][0]['url'],
                      artistName: data['artists'][index]['name'],
                    )
                  )),
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(80)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/Images/artist.png',
                              image:data['artists'][index]['images'][0]['url'], 
                              height: 150,width: 150,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['artists'][index]['name'],overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                 
              );
            }); 
        } 
        else return Container(); 
      }
    ); 
  }
}