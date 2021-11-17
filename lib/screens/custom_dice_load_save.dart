import 'dart:math';
import 'dart:async';
import 'package:advice_dice_3/models/dice_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiceListTile extends StatelessWidget {
  final int position;
  final List<TextEditingController> textArrayControllers;

  DiceListTile(this.position, this.textArrayControllers);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('Dice' + position.toString()),
      title: TextField(controller: textArrayControllers[position - 1]),
    );
  }
}

class CustomizeDiceLoadSave extends StatefulWidget {
  @override
  _CustomizeDiceLoadSaveState createState() => _CustomizeDiceLoadSaveState();
}

class _CustomizeDiceLoadSaveState extends State<CustomizeDiceLoadSave> {
  final _firestore = FirebaseFirestore.instance;
  static final List<TextEditingController> textArrayControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  String codeText = 'firebase';

  DiceWords localDiceWord = DiceWords.empty(); // just initing with something
  // TODO: Consider continuously updating the Provider.of<Dicewords> as the single source of truth. This would require binding the TextControllers to the state above.


  @override
  void dispose() {
    // var a? = Provider.of<DiceWords>(context, listen: false);
    // print(a);

//    Provider.of<DiceWords>(context, listen: false)  // main DiceWord instance in the app.
//        .copyInto(localDiceWord.wordList);
    print(" dispose");
    super.dispose();
  }

  @override
  void deactivate() {
    print("deactivate");
    // Provider.of<DiceWords>(context, listen: false)  // main DiceWord instance in the app.
    //     .copyInto(localDiceWord.wordList);   // different error, about widget drawing lifecycle. This calls notifyListeners, which is maybe a no-no-at this point.

    super.deactivate();
  }




  void onDone() {
    Provider.of<DiceWords>(context, listen: false)  // main DiceWord instance in the app.
            .copyInto(textArrayControllers.map((te) => te.text).toList());
    // Navigator.pushNamed(context, '/');
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void reloadDiceWordsDisplay(String code) {
    for (var i = 0; i < 6; i++) {
      // print(i);
      // print(textArrayControllers[i].text);
      textArrayControllers[i].text = localDiceWord.wordList[i];
      // print(textArrayControllers[i].text);
    }
    setState(() {
      codeText = code;
    });
  }

  void _LoadBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        final diceCodeTextFieldDecoration = InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Please Enter Dice Code',
          suffixStyle: TextStyle(color: Colors.green),
        );
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  title: Text('DEBUG shortcut: Boring - Click to Get - remove later'),
                  onTap: () async {
                    var doc = await _firestore.doc('DiceWords/Boring');
                    await doc.get().then((DocumentSnapshot ds) {
                      localDiceWord.copyInto(List.from(ds['wordList']));
                    });
                    reloadDiceWordsDisplay('Boring');
                  }),
              ListTile(
                leading: new Icon(Icons.satellite),
                title: TextField(
                  keyboardType: TextInputType.text,
                  decoration: diceCodeTextFieldDecoration,
                  maxLines: 1,
                  onSubmitted: (String code) async {
                    var doc = await _firestore.doc('DiceWords/$code');
                    await doc.get().then((DocumentSnapshot ds) {
                      if (ds.data == null) {
                        print('ERROR: No Code Found');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Code not found'),
                            );
                          },
                        );
                      } else {
                        localDiceWord.copyInto(List.from(ds['wordList']));
                        reloadDiceWordsDisplay(code);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _SaveDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String enteredCodeText;

        return AlertDialog(
          title: Text(
              'EnterSaveCode, if it is already in use, a random number will be added'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Please Enter Dice Code',
                    hintText: 'CaseMatters',
                  ),
                  onChanged: (value) {
                    enteredCodeText =
                        value; // might want to precheck the code after a pause.
                  },
                  onSubmitted: (code) async {
                    // check if value exists in database
                    var doc = await _firestore.doc('DiceWords/$code');
                    await doc.get().then((DocumentSnapshot ds) {
                      if (ds.data() == null) {
                        print('GOOD FOR SAVING:  No Code Found');
                        var enteredDiceList =
                            textArrayControllers.map((te) => te.text).toList();
                        _firestore.doc('DiceWords/$code').set(
                          {
                            'wordList': enteredDiceList,
                          },
                        );
                        localDiceWord.copyInto(enteredDiceList);
                        setState(() {
                          codeText = code;
                        });
                        Navigator.pop(context, null);
                      } else {
                        print("Is this printing?");
                        print(ds.toString());
                        // if not, append a random 3 digit number to the end, checking if unique each time.  If cannot find after 50 tries, append a 6 digit number.
                        print('Error!! Need to write this code.');
                      }
                    });
                    // TODO: close dialog
                  },
                ),
              )
            ],
          ),
          actions: null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // STUB FOR SAVING TO THE DATABASE
//    _firestore.doc('DiceWords/Shawn').setData({
//      'wordList': DiceWordsBuiltIn.b3.wordList
//    });

    return Scaffold(
      appBar: AppBar(
          title: Text('Advice Dice - Load Special'),
          automaticallyImplyLeading: false
      ),
      body: Container(
        color: Colors.amber[100],
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            DiceListTile(1, textArrayControllers),
            DiceListTile(2, textArrayControllers),
            DiceListTile(3, textArrayControllers),
            DiceListTile(4, textArrayControllers),
            DiceListTile(5, textArrayControllers),
            DiceListTile(6, textArrayControllers),
            RaisedButton(
              child: Text('Done'),
              onPressed: onDone,
            ),
            Divider(),
            RaisedButton(
              child: Text('Load Firebase'),
              onPressed: () {
                _LoadBottomSheet(context);
              },
            ),
            RaisedButton(
              child: Text('Save Firebase'),
              onPressed: () {
                _SaveDialog(context);
              },
            ),
            Text(codeText),
          ],
        ),
      ),
    );
  }
}
