import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DiceWords extends ChangeNotifier {
  final List<String> wordList;

  DiceWords(this.wordList)
      : assert(wordList.length == 6, "List not 6 elements");

  DiceWords.empty()
    : wordList=['','','','','',''];

  void copyInto(List<String> s) {
    if (s.length>=6) {
      wordList.setRange(0,6,s);
      notifyListeners();
      return null;
    }
    else {
      return null;
    }

  }


}

class DiceWordsBuiltInArray{
  static List<DiceWords> b=
  [
    DiceWordsBuiltIn.b1,
    DiceWordsBuiltIn.b2,
    DiceWordsBuiltIn.b3,
    DiceWordsBuiltIn.b4,
    DiceWordsBuiltIn.b5,
  ];
}

class DiceWordsBuiltIn{
  static final DiceWords b1 = DiceWords([
    'Take a Shower',
    'Eat Something',
    'Call your Mom',
    'Take a Nap',
    'Clean Up',
    'Dance it Out',
  ]);

  static final DiceWords b2 = DiceWords([
    // Katie
    'Food',
    'See/Feel Water',
    'Trees',
    'Drink Water',
    'Warmth',
    'Nap',
  ]);

  static final DiceWords b3 = DiceWords([
    // Shawn
    'Burgers',
    'Eggs',
    'Peanuts',
    'Rice',
    'Tea',
    'Powerade',
  ]);

  static final DiceWords b4 = DiceWords([
    // Ten C.
    'Go to Planet Fitness',
    'Costco Gas',
    'Watch CCTV4',
    'Wipe Car with Rag',
    'Ponder Hateful Heirs',
    'Watch YouTube',
  ]);

  static final DiceWords b5 = DiceWords([
    // Mom.
    '恐怖分子', // terrorist, konbu fenzi
    '没有空',  // mei you kong
    '流浪汉', // Liúlàng hàn
    '无可奈何', // Wu ke nai he, helpless
    '可有可无', // Ke you, ke wu,  irrelevant, optional, expendable
    '我爱YouTube',  // Wo ai Youtube.
  ]);
}


class Counter extends ChangeNotifier {
  /// Internal, private state of the cart.
  num _count  = 0;


  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void increment() {
    _count++;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void resetToZero() {
    _count=0;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}