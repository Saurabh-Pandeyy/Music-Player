import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/HomePage/MyMusicPage.dart';
import 'package:music_player/Screens/HomePage/MyVideosPage.dart';
import 'package:music_player/Screens/HomePage/OnlineMusicPage.dart';
import 'package:music_player/ViewModels/HomePageViewModel.dart';



class HomePage extends StatelessWidget {

  final List<Widget> screens = [

    OnlineMusicPage(),
    MyMusicPage(),
    MyVideosPage()
    
  ];


  @override
  Widget build(BuildContext context) {


    //provider currenttrack

    HomePageViewModel controller = Get.put(HomePageViewModel());

    return Scaffold(
      
      appBar: AppBar(
         
        backgroundColor: Colors.black,
        title: Text('Music Player',style: GoogleFonts.croissantOne()),    
        
      ),

      drawer: Drawer(),


      body: Obx(() =>
        IndexedStack(       // for preserving state of screens
          children: screens,
          index: controller.currentIndex.value,
        ),
      ),

       

      bottomNavigationBar: Obx(() =>

        BottomNavigationBar(
      
          unselectedFontSize: 0,
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          elevation: 5,
          unselectedItemColor: Colors.black,
          selectedItemColor: Color(0xff0050bc),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index){
            controller.currentIndex.value = index;
          },
      
          items: [
      
            BottomNavigationBarItem(
            
              icon: ImageIcon(AssetImage('lib/Images/SpotifyLogo.png')),
              label: 'Online'
            ),
      
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined,),
              label: 'My music'
            ),
      
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              label: 'Video'
            ),
      
          ],
        ),
      ),

    );
  }
}