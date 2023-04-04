import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNextWord() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    favorites.contains(current)
        ? favorites.remove(current)
        : favorites.add(current);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritePage();
        break;
      case 2:
        page = Text("Mouse Page");
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 500,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text("Favorites")),
                  NavigationRailDestination(
                      icon: Icon(Icons.mouse), label: Text("Mouse Home"))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            )),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var newWordPair = appState.current;

    //******adding icons */
    IconData icon;

    //****checking if the word is already liked and in the favorite variable */
    appState.favorites.contains(newWordPair)
        ? icon = Icons.favorite
        : icon = Icons.favorite_border;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(newWordPair: newWordPair),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavorite();
                    },
                    icon: Icon(icon),
                    label: Text('Like Word')),
                SizedBox(
                    width: 10), //*****to give a gap between the two buttons */
                ElevatedButton(
                    onPressed: () {
                      appState.getNextWord();
                    },
                    child: Text('Get Next Word')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favWords = appState.favorites;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${favWords.length} favorites'),
        ),
        for (var favWord in favWords)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(favWord.asLowerCase),
          ),
      ],
    );

    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text("Fav Words"),
    //         // Text('$favWord')
    //         for(var favWord in favWords)
    //         BigCard(newWordPair: favWord),
    //       ]

    //     ),
    //   ),
    // );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.newWordPair,
  });

  final WordPair newWordPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          newWordPair.asLowerCase,
          style: style,
          semanticsLabel: "${newWordPair.first} ${newWordPair.second}",
        ),
      ),
    );
  }
}
