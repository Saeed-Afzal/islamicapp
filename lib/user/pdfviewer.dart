// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PDFViewerWidget extends StatefulWidget {
//   final String pdfPath;

//   const PDFViewerWidget({required this.pdfPath});

//   @override
//   _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
// }

// class _PDFViewerWidgetState extends State<PDFViewerWidget> {
//   int currentPage = 0;
//   late PDFViewController pdfViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PDFView(
//               filePath: widget.pdfPath,
//               onPageChanged: (int? page, int? total) {
//                 if (page != null && total != null) {
//                   setState(() {
//                     currentPage = page;
//                   });
//                 }
//               },
//               onViewCreated: (PDFViewController controller) {
//                 pdfViewController = controller;
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.chevron_left),
//                 onPressed: () {
//                   if (currentPage > 0) {
//                     pdfViewController.setPage(currentPage - 1);
//                   }
//                 },
//               ),
//               Text('Page ${currentPage + 1}'),
//               IconButton(
//                 icon: Icon(Icons.chevron_right),
//                 onPressed: () {
//                   pdfViewController.setPage(currentPage + 1);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PDFViewerWidget extends StatefulWidget {
  final String pdfPath;

  const PDFViewerWidget({required this.pdfPath});

  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> with WidgetsBindingObserver{
    late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
    Stopwatch _stopwatch = Stopwatch();
  bool _isDisposed = false;
   int _coins = 0;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
        WidgetsBinding.instance.addObserver(this);
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
  int currentPage = 0;
  // late PDFViewController pdfViewController;

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
      body: SfPdfViewer.asset(
        'assets/quran.pdf',
          // 'https://firebasestorage.googleapis.com/v0/b/islamic-app-e6a18.appspot.com/o/pdf%2F13-Line-Quran-with-Tajweed-rule.pdf?alt=media&token=2d0e56ba-f86c-4fb2-8b32-4c2d98c6af75',
          // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
          controller: _pdfViewerController,
          key: _pdfViewerStateKey),
      appBar: AppBar(
        title: Text("Read Quran"),
                backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _pdfViewerStateKey.currentState!.openBookmarkView();
              },
              icon: Icon(
                Icons.bookmark,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                _pdfViewerController.jumpToPage(5);
              },
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                _pdfViewerController.zoomLevel = 1.25;
              },
              icon: Icon(
                Icons.zoom_in,
                color: Colors.white,
              ))
        ],
      ),
    ));
  }
}
