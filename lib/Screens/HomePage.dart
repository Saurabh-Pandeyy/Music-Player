import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:music_player/Services/DataServices.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Card(
              elevation: 8,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: ListTile(
                leading: Icon(Icons.search),
                title: Text('Search'),
                trailing: CircleAvatar(),
              ),
            ),

            Expanded(
              child: FutureBuilder(
                future: DataServices().getData(), 
                builder: (context,snap){

                  if(snap.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if(snap.data != null){

                    var data = jsonDecode(snap.data.body);
                   
                    return  ListView.builder(
                      itemCount: data['items'].length,
                      itemBuilder: (context,index){
                        return InkWell(
                                                  child: Container(
                            height: 150,width: 150,
                            child: Image.network(data['items'][index]['images'][0]['url']),
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute( 
                      builder:(context) => Home()
                    ))
                        );
                      }); 
                  }
                  else return Container();
                }),
            )
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(height: 100,width: 100,color: Colors.red),
      ),
    );

  }
}