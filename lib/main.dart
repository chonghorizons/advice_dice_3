import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:flutter/cupertino.dart';
import 'package:advice_dice_3/screens/custom_dice_load_save.dart';
import 'package:advice_dice_3/screens/start_page.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:advice_dice_3/models/dice_words.dart';

// TODO: Crossfire
// TODO: Add fluro to handle routes for flutter web. Including custom route that can be shared by putting info in the url, maybe as query, maybe as param
// TODO: Add Firebase to store/load saved AdviceDice. Including from others.
// TODO: quick custom: Edit the 6 items.
// TODO: Manage Dice page.

void main() {


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => DiceWords(DiceWordsBuiltIn.b1.wordList))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: {


          '/': (context) => StartPage(),
//          '/customSet1': (context) => StartPage(),
//          '/customSet2': (context) => StartPage(),
//          '/customSet3': (context) => StartPage(),
//          '/customSet4': (context) => StartPage(),
//        '/': (context) => StartPage(diceWords: DiceWordsBuiltIn.b1),
//        '/customSet1': (context) => StartPage(diceWords: DiceWordsBuiltIn.b1),
//        '/customSet2': (context) => StartPage(diceWords: DiceWordsBuiltIn.b2),
//        '/customSet3': (context) => StartPage(diceWords: DiceWordsBuiltIn.b3),
//        '/customSet4': (context) => StartPage(diceWords: DiceWordsBuiltIn.b4),
          '/customizeDice': (context) => CustomizeDiceLoadSave(),
          // '/customize6view': (context) => Custom6PageView(), // May not be needed if the Provider is changed.
          // uses a code to load a preset from firebase
        },
        onGenerateRoute: (settings) {
          print(settings.name);
          if (settings.name == "/happy") {
            return MaterialPageRoute(
              builder: (context) => StartPage(),
              settings: RouteSettings(name: '/happy'),
            );
          }
          return MaterialPageRoute(
            builder: (context) => StartPage(),
            settings: RouteSettings(name: '/sad'),
          );
        },
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// TODO: Prompt for some type of code like HTD3552 which goes to firebase and loads up a set.

