import 'package:advice_dice_3/models/dice_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  double wheelOpacity = 0.1;

  // TODO: Figure out if I need a StatefulWidget here. Or if there is a better way.
  // Issue of making stateless: If stateless, I could pass an opacity parameter. But, somewhere, I'd have to remember the UI state variable. And I'd have to remember that switch the wheelOpacity to 0.1 whenever a new wordList is loaded.

  final FixedExtentScrollController wheelController =
  FixedExtentScrollController(initialItem: 40 + Random().nextInt(12));

  void onTapChange(int index) {
    // can be run from anywhere.
    Provider.of<DiceWords>(context, listen: false).wordList =
        DiceWordsBuiltInArray.b[index].wordList;
    print("OnTapChange");
    print(Provider.of<DiceWords>(context, listen: false).wordList.toString());
    Navigator.pushNamed(context, '/');
  }

  void onTapChangev2(int index) {
    // has to be run from a display page because it needs setState()
    setState(() {
      Provider.of<DiceWords>(context, listen: false).wordList =
          DiceWordsBuiltInArray.b[index].wordList;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var displayedDiceWords = Provider.of<DiceWords>(context);
    print('Rerender Display');
    print(displayedDiceWords.wordList);
    return Scaffold(
      drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Icon(Icons.ac_unit),
                onTap: () => Navigator.pushNamed(context, '/customizeDice'),
              ),
              ListTile(
                title: Text('Howard'),
                onTap: () => onTapChange(0),
              ),
              ListTile(
                title: Text('Katie'),
                onTap: () => onTapChange(1),
              ),
              ListTile(
                title: Text('Shawn'),
                onTap: () => onTapChangev2(2),
              ),
              ListTile(
                  title: Text('Ten C.'),
                  onTap: () {
                    setState(() {
                      Provider.of<DiceWords>(context, listen: false).wordList =
                          DiceWordsBuiltInArray.b[3].wordList;
                    });
                    Navigator.pop(context);
                  }),
              ListTile(
                title: Text('中文'),
                onTap: () => onTapChangev2(4),
              ),
              ListTile(
                  title: Text('Another Chinese'),
                  onTap: () {
                    setState(() {
                      Provider.of<DiceWords>(context, listen: false).wordList =
                          DiceWordsBuiltInArray.b[4].wordList;
                    });
                    Navigator.pushNamed(context, '/another');
                  }),
            ],
          )),
      appBar: AppBar(
        title: Text('Advice Dice'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('images/dice_animation_blue_infinite.gifv', height: 80),
            Text(
              'ADVICE DICE',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Opacity(
              opacity: this.wheelOpacity,
              child: Container(
                color: Colors.lightBlueAccent,
                width: 400.0,
                height: 400.0,
                child: LimitedBox(
                  maxWidth: 400.0,
                  maxHeight: 400.0,
                  child: CupertinoPicker.builder(
                    itemExtent: 35.0,
                    childCount: 100,
                    // backgroundColor: Colors.blue[300],
                    itemBuilder: (context, index) =>
                        PieceOfAdvice(displayedDiceWords, index),
                    useMagnifier: true,
                    magnification: 1.5,
                    onSelectedItemChanged: null,
                    scrollController: this.wheelController,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            this.wheelOpacity = 1.0;
            this.wheelController.animateToItem(
                (this.wheelController.selectedItem + Random().nextInt(80)) %
                    100,
                duration: Duration(milliseconds: Random().nextInt(3000) + 1500),
                curve: Curves.decelerate);
          });
        },
        tooltip: 'Increment',
        child: Text('Spin'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PieceOfAdvice extends StatelessWidget {
  final DiceWords diceWords;
  final int index;

  PieceOfAdvice(this.diceWords, this.index);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200.0,
        color: Colors.blue,
        child: Center(child: Text(diceWords.wordList[index % 6])),
      ),
    );
  }
}
