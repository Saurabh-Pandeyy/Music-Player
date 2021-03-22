import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Widgets/CurrentTrack.dart';
import 'package:provider/provider.dart';


class SliverBar extends StatefulWidget  {

  final backgroundImage;
  final appbarTitle;
  final dataList;

  SliverBar({Key key,@required this.backgroundImage,@required this.appbarTitle,@required this.dataList}) : super(key: key);

  @override
  _SliverBarState createState() => _SliverBarState(); 
}

class _SliverBarState extends State<SliverBar> with TickerProviderStateMixin {
 
  List currentTrackData;
  AnimationController imageController;
  AnimationController iconController;

  @override
  void initState() {
    super.initState();
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
    currentTrackData = Provider.of<CurrentTrack>(context).getCurrentTrackDetails();
  
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          
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
                  background: Image.network(widget.backgroundImage,fit: BoxFit.cover,),
                  title: Text(constraints.biggest.height != top ? '' : widget.appbarTitle,style: GoogleFonts.roboto())
                );
              },
            ) 
            
          ),

          SliverList(delegate: SliverChildListDelegate(
            widget.dataList != null ? widget.dataList : [Container()]
          ),),
        ], 
      ), 
      
      bottomNavigationBar:currentTrackData[1] != null ? BottomAppBar(
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
                    print(data.trackPlayer.state);
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
}