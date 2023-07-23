import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import '../constants/constants.dart';
import '../models/translation.dart';
import '../services/api_services.dart';
import '../widgets/custom_translation.dart';



enum Translation { urdu,hindi,english, spanish }

class Surahdetail extends StatefulWidget {
  const Surahdetail({Key? key}) : super(key: key);

  static const String id = 'surahDetail_screen';

  @override
  _SurahdetailState createState() => _SurahdetailState();
}

class _SurahdetailState extends State<Surahdetail> {
  ApiServices _apiServices = ApiServices();
  Translation? _translation = Translation.urdu;
  int _currentPage = 0;
  int _linesPerPage = 15;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Read Surah'),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
          future: _apiServices.getTranslation(
            Constants.surahIndex!,
            _translation!.index,
          ),
          builder: (BuildContext context, AsyncSnapshot<SurahTranslationList> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final totalLines = snapshot.data!.translationList.length;
              final totalPages = (totalLines / _linesPerPage).ceil();

              return PageView.builder(
                itemCount: totalPages,
                controller: PageController(initialPage: _currentPage),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  final startLine = pageIndex * _linesPerPage;
                  final endLine = (startLine + _linesPerPage < totalLines)
                      ? startLine + _linesPerPage
                      : totalLines;

                  final linesToShow = snapshot.data!.translationList.sublist(startLine, endLine);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ListView.builder(
                      itemCount: linesToShow.length,
                      itemBuilder: (context, index) {
                        return TranslationTile(
                          index: index + startLine,
                          surahTranslation: linesToShow[index],
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('Translation Not found'));
            }
          },
        ),
      ),
    );
  }
}


// class _SurahdetailState extends State<Surahdetail> {

//   ApiServices _apiServices = ApiServices();
//   //SolidController _controller = SolidController();
//   Translation? _translation = Translation.urdu;


//   @override
//   Widget build(BuildContext context) {
//     print(_translation!.index);

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: Text('Read Surah'), backgroundColor: Colors.green,),
//         body: FutureBuilder(
//           future: _apiServices.getTranslation(Constants.surahIndex!,_translation!.index),
//           builder: (BuildContext context, AsyncSnapshot<SurahTranslationList> snapshot){
//             if(snapshot.connectionState == ConnectionState.waiting){
//               return Center(child: CircularProgressIndicator(),);
//             }
//             else if(snapshot.hasData){
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 50),
//                 child: ListView.builder(
//                   itemCount: snapshot.data!.translationList.length,
//                   itemBuilder: (context,index){
//                     return TranslationTile(index: index,
//                         surahTranslation: snapshot.data!.translationList[index],
//                     );
//                   },
//                 ),
//               );
//             }
//             else return Center(child: Text('Translation Not found'),);
//           },
//         ),
//         // bottomSheet: SolidBottomSheet(
//         //   headerBar: Container(
//         //     color: Theme.of(context).primaryColor,
//         //     height: 50,
//         //     child: Center(
//         //       child: Text("Swipe me!",style: TextStyle(color: Colors.white),),
//         //     ),
//         //   ),
//         //   body: Container(
//         //     color: Colors.white,
//         //     height: 30,
//         //     child: SingleChildScrollView(
//         //       child: Center(
//         //         child: Column(
//         //           children: <Widget>[
//         //             ListTile(
//         //               title: const Text('Urdu'),
//         //               leading: Radio<Translation>(
//         //                 value: Translation.urdu,
//         //                 groupValue: _translation,
//         //                 onChanged: (Translation? value) {
//         //                   setState(() {
//         //                     _translation = value;
//         //                   });
//         //                 },
//         //               ),
//         //             ),
//         //             ListTile(
//         //               title: const Text('Hindi'),
//         //               leading: Radio<Translation>(
//         //                 value: Translation.hindi,
//         //                 groupValue: _translation,
//         //                 onChanged: (Translation? value) {
//         //                   setState(() {
//         //                     _translation = value;
//         //                   });
//         //                 },
//         //               ),
//         //             ),
//         //             ListTile(
//         //               title: const Text('English'),
//         //               leading: Radio<Translation>(
//         //                 value: Translation.english,
//         //                 groupValue: _translation,
//         //                 onChanged: (Translation? value) {
//         //                   setState(() {
//         //                     _translation = value;
//         //                   });
//         //                 },
//         //               ),
//         //             ),
//         //             ListTile(
//         //               title: const Text('Spanish'),
//         //               leading: Radio<Translation>(
//         //                 value: Translation.spanish,
//         //                 groupValue: _translation,
//         //                 onChanged: (Translation? value) {
//         //                   setState(() {
//         //                     _translation = value;
//         //                   });
//         //                 },
//         //               ),
//         //             ),
//         //           ],
//         //         )
//         //       ),
//         //     ),
//         //   ),
//         // ),
      
      
//       ),
//     );
//   }
// }
