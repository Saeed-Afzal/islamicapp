// import 'package:flutter/material.dart';
// import 'package:islamicapp/user/surah_detail.dart';

// import '../constants/constants.dart';
// import '../models/sajda.dart';
// import '../models/surah.dart';
// import '../services/api_services.dart';
// import '../widgets/sajda_custom_tile.dart';
// import '../widgets/surah_custem_tile.dart';
// import 'jus_screen.dart';

// class QuranScreen extends StatefulWidget {
//   const QuranScreen({Key? key}) : super(key: key);

//   @override
//   _QuranScreenState createState() => _QuranScreenState();
// }

// class _QuranScreenState extends State<QuranScreen> {

//   ApiServices apiServices = ApiServices();

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Added
//       initialIndex: 0,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Read Quran'),
//             backgroundColor: Colors.green,
//             centerTitle: true,
//             bottom: TabBar(
//               tabs: [
//                 Text(
//                   'Surah',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 20),
//                 ),//index - 0
//                 // Text(
//                 //   'Sajda',
//                 //   style: TextStyle(
//                 //       color: Colors.white,
//                 //       fontWeight: FontWeight.w700,
//                 //       fontSize: 20),
//                 // ),//index - 1
//                 Text(
//                   'Juz',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 20),
//                 ),// index - 2
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children:  <Widget>[
//               FutureBuilder(
//                 future: apiServices.getSurah(),
//                 builder: (BuildContext context, AsyncSnapshot<List<Surah>> snapshot) {
//                   if (snapshot.hasData) {
//                     List<Surah>? surah = snapshot.data;
//                     return ListView.builder(
//                       itemCount: surah!.length,
//                       itemBuilder: (context, index) => SurahCustomListTile(surah: surah[index],
//                           context: context, ontap: (){
//                             setState(() {
//                               Constants.surahIndex = (index + 1);
//                             });
//                             // Navigator.pushNamed(context, Surahdetail.id);
//                             showDialog(context: context, builder: (BuildContext context){
//                               return AlertDialog(
//                                 title: const Text('Work is in Pending'),
//                               );
//                             });
//                           }),
//                      );
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//               // FutureBuilder(
//               //   future: apiServices.getSajda(),
//               //   builder: (context,AsyncSnapshot<SajdaList> snapshot){
//               //     if(snapshot.hasError){
//               //       return Center(child: Text('Something went wrong'),);
//               //     }
//               //     if(snapshot.connectionState == ConnectionState.waiting){
//               //       return Center(child: CircularProgressIndicator(),);
//               //     }
//               //     return ListView.builder(
//               //       itemCount: snapshot.data!.sajdaAyahs.length,
//               //       itemBuilder: (context , index) => SajdaCustomTile(snapshot.data!.sajdaAyahs[index], context),
//               //     );
//               //   },
//               // ),
//               GestureDetector(
//                 child: Container(
//                   padding: EdgeInsets.all(8.0),
//                   child: GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//                     itemCount: 30,
//                     itemBuilder: (context,index){
//                       return GestureDetector(
//                         onTap: (){
//                           setState(() {
//                             Constants.juzIndex = (index + 1);
//                           });
//                           // Navigator.pushNamed(context, JuzScreen.id);
//                           Navigator.pushNamed(context, JuzScreen.id);
//                         },
//                         child: Card(
//                           elevation: 4,
//                           // color: Colors.blueGrey,
//                           color: Colors.white,
//                           child: Center(
//                             child: Text('${index+1} ',style: TextStyle(color: Colors.green,fontSize: 20),),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// --------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:islamicapp/user/surah_detail.dart';

import '../constants/constants.dart';
import '../models/sajda.dart';
import '../models/surah.dart';
import '../services/api_services.dart';
import '../widgets/sajda_custom_tile.dart';
import '../widgets/surah_custem_tile.dart';
import 'jus_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with WidgetsBindingObserver {
  ApiServices apiServices = ApiServices();
  Stopwatch _stopwatch = Stopwatch();
  bool _isDisposed = false;
   int _coins = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isDisposed) {
        _isDisposed = false;
        _startTimer();
      }
    } else if (state == AppLifecycleState.paused) {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _stopTimer();
    _isDisposed = true;
    super.dispose();
  }

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
  }

  Future<void> _stopTimer() async {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      // Save the timer value to the user collection
      // Replace the following line with your own logic to save the timer value
      print('Timer value: ${_stopwatch.elapsed}');
      Duration elapsedTime = _stopwatch.elapsed;
      int minutes = elapsedTime.inMinutes;
      // Add coins based on elapsed time
      int coinsToAdd = minutes ~/ 1;
      _coins += coinsToAdd;
      // Save the timer value to the user collection
      // Replace the following line with your own logic to save the timer value and coins
      print('Timer value: ${_stopwatch.elapsed}');
      print('Coins: $_coins');
      
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

            await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'coins': FieldValue.increment(_coins),
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _startTimer();
    });

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Read Quran'),
            backgroundColor: Colors.green,
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Text(
                  'Surah',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Juz',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                future: apiServices.getSurah(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Surah>> snapshot) {
                  if (snapshot.hasData) {
                    List<Surah>? surah = snapshot.data;
                    return ListView.builder(
                      itemCount: surah!.length,
                      itemBuilder: (context, index) => SurahCustomListTile(
                        surah: surah[index],
                        context: context,
                        ontap: () {
                          setState(() {
                            Constants.surahIndex = (index + 1);
                          });
                          Navigator.pushNamed(context, Surahdetail.id);
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: const Text('Work is in Pending'),
                          //     );
                          //   },
                          // );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Constants.juzIndex = (index + 1);
                          });
                          Navigator.pushNamed(context, JuzScreen.id);
                        },
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              '${index + 1} ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
