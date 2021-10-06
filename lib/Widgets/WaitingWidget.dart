import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

  Widget homePageWaitingWidget(){
    return Shimmer.fromColors(
      baseColor: Color(0xffe0e0e0),   
      highlightColor: Color(0xfff5f5f5), 
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect( 
              borderRadius:  BorderRadius.circular(13),
              child: Container(
                width: 150,
                color: Colors.white,
              ),
            ),
          ), 
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect( 
              borderRadius:BorderRadius.circular(13),   
              child: Container(
                width: 150,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(  
              child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: ClipRRect( 
                borderRadius:BorderRadius.circular(13),   
                child: Container(
                  width: 150,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ); 
  }

  Widget detailsPageWaitingWidget(){
    return Container(
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: Color(0xffe0e0e0),   
        highlightColor: Color(0xfff5f5f5), 
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context,index){
            return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(  
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: Colors.white,
                    height: 80,width: 80,
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 500,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10))
                        ),
                      ),
                    ) 
                  ],
                ),
              ) ,
            ],
          );
          },
          
        ),
      ),
    ); 
  }