// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class TestWidget extends StatefulWidget {
//   const TestWidget({super.key});
//
//   @override
//   State<TestWidget> createState() => _TestWidgetState();
// }
//
// class _TestWidgetState extends State<TestWidget> {
//   List<String> texts = ['PAGE 1', 'PAGE 2', 'PAGE 3'];
//   bool isVisible = false;
//   int index = 0;
//   Timer? _visibilityTimer;
//
//   @override
//   void initState(){
//     super.initState();
//     dragStatus();
//
//   }
//
//   void dragStatus() {
//     setState(() {
//       isVisible = true;
//     });
//
//     // Cancel any existing timer and start a new one
//     _visibilityTimer?.cancel();
//     _visibilityTimer = Timer(Duration(seconds: 5), () {
//       setState(() {
//         isVisible = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // Cancel the timer when the widget is disposed to prevent memory leaks
//     _visibilityTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanUpdate: (drag) {
//         if (drag.delta.dx < 0) {
//           print(drag.delta.dy);
//           dragStatus();
//         }
//         else{
//           setState(() {
//             isVisible = false;
//           });
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       texts[index],
//                       style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height : 300,
//                       child : CarouselSlider(
//                         options: CarouselOptions(
//                             viewportFraction: 1,
//                             height: 400.0),
//                         items: [1,2,3,4,5].map((i) {
//                           return Builder(
//                             builder: (BuildContext context) {
//                               return Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                                   decoration: BoxDecoration(
//                                       color: Colors.amber
//                                   ),
//                                   child: Text('text $i', style: TextStyle(fontSize: 16.0),)
//                               );
//                             },
//                           );
//                         }).toList(),
//                       )
//                     )
//                   ],
//                 ),
//               ),
//
//               AnimatedPositioned(
//                 duration: isVisible ? Duration(milliseconds:  300) : Duration(seconds: 2),
//                 right: isVisible ? 0 : -200, // Adjust the value to control the animation
//                 top: 0,
//                 child: Column(
//                   children: [
//                     ...texts.map((e) {
//                       final newIndex = texts.indexOf(e);
//                       return InkWell(
//                         splashColor: Colors.transparent,
//                         onTap: () {
//                           setState(() {
//                             index = newIndex;
//                           });
//                           dragStatus();
//                         },
//                         child: Card(
//                           margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//                           elevation: index == newIndex ? 10 : 0,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey,
//                               border: Border.all(color: Colors.black),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8),
//                                 bottomLeft: Radius.circular(8),
//                               ),
//                             ),
//                             padding: EdgeInsets.all(8),
//                             child: Center(child: Text(e)),
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
