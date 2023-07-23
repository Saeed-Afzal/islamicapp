import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/qari.dart';
import '../services/api_services.dart';
import '../widgets/qari_custom_tile.dart';
import 'audio_surah_screen.dart';

class QariListScreen extends StatefulWidget {
  const QariListScreen({Key? key}) : super(key: key);

  @override
  _QariListScreenState createState() => _QariListScreenState();
}

class _QariListScreenState extends State<QariListScreen> with WidgetsBindingObserver{
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('List of Qari\'s '),centerTitle: true, backgroundColor: Colors.green,),
        body: Padding(
          padding: const EdgeInsets.only(top: 20,left: 12,right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 12,),
              // Container(
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(32),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black54,
              //           blurRadius: 1,
              //           spreadRadius: 0.0,
              //           offset: Offset(0,1),
              //         ),
              //       ]
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Row(
              //       children: [
              //         Text('Search',style: TextStyle(fontSize: 20),),
              //         Spacer(),
              //         Icon(Icons.search),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20,),
              Expanded(
                child: FutureBuilder(
                  future: apiServices.getQariList(),
                  builder: (BuildContext context , AsyncSnapshot<List<Qari>> snapshot){
                    if(snapshot.hasError){
                      return Center(child: Text('Qari\'s data not found '),);
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context , index){
                        return QariCustomTile(qari: snapshot.data![index],
                            ontap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder:(context)=>
                                      AudioSurahScreen(qari: snapshot.data![index])));
                            });
                      },
                    );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
