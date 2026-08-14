import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {

        '/gameOtherPage': (context) => OtherPage(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListPage(),

      );
  }
  Widget ListPage() {
    return Column(
      children: [
        ElevatedButton(
          child: Text("Add item"),
          onPressed: () {
            DataRepository.trigger = false;
            Navigator.pushNamed(context, "/gameOtherPage");
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: DataRepository.count,
            itemBuilder: (context, rowNum) {
              return GestureDetector(
                onTap: () {
                  DataRepository.trigger = true;
                  DataRepository.count1 = rowNum;
                  Navigator.pushNamed(context, "/gameOtherPage");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("date:" + DataRepository.date[rowNum]),
                    Text("Stadium:" + DataRepository.StadiumIDnumber[rowNum]),
                    Text("Team 1:" + DataRepository.StadiumIDnumber[rowNum]),
                    Text("Team 2:" + DataRepository.StadiumIDnumber[rowNum]),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
class OtherPage extends StatefulWidget {
  @override
  State<OtherPage> createState() => OtherPageState();
}
class OtherPageState extends State<OtherPage> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DataRepository.trigger
        ? alter()
        : add(),
    /*
    (Column(children: [TextField(controller: _controller1, decoration: InputDecoration(labelText: "date"))
      ,TextField(controller: _controller2, decoration: InputDecoration(labelText: "Stadium ID number")),
      TextField(controller: _controller3, decoration: InputDecoration(labelText: "Team 1 ID number")),
      TextField(controller: _controller4, decoration: InputDecoration(labelText: "Team 2 ID number")),
      ElevatedButton(
        onPressed: () {
          if(
              _controller1.value.text.isEmpty ||
              _controller2.value.text.isEmpty ||
              _controller3.value.text.isEmpty ||
              _controller4.value.text.isEmpty
          ){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar (content: Text('Error')));
          }else{
            DataRepository.date[DataRepository.count] = _controller1.value.text;
            DataRepository.StadiumIDnumber[DataRepository.count] = _controller2.value.text;
            DataRepository.team1IDnumber[DataRepository.count] = _controller3.value.text;
            DataRepository.team2IDnumber[DataRepository.count] = _controller4.value.text;
            DataRepository.count++;
            Navigator.pushNamed(context,"/" );
        };

          }, //  <--- Lambda function
        child:Text("submit"),
      )
    ],
    )
    )
    );
     */
     //Use a Scaffold to layout a page with an AppBar and main body region
    );
  }
  List<String> words =  [] ;
  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    if(DataRepository.trigger){
      _controller1.text = DataRepository.date[DataRepository.count1];
      _controller2.text = DataRepository.StadiumIDnumber[DataRepository.count1];
      _controller3.text = DataRepository.team1IDnumber[DataRepository.count1];
      _controller4.text = DataRepository.team2IDnumber[DataRepository.count1];
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  Widget add() { // Fixed: Changed return type to Widget for clarity
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: _controller1, decoration: InputDecoration(labelText: "date")),
          TextField(controller: _controller2, decoration: InputDecoration(labelText: "Stadium ID number")),
          TextField(controller: _controller3, decoration: InputDecoration(labelText: "Team 1 ID number")),
          TextField(controller: _controller4, decoration: InputDecoration(labelText: "Team 2 ID number")),
          ElevatedButton(
            onPressed: () {
              if (_controller1.text.isEmpty ||
                  _controller2.text.isEmpty ||
                  _controller3.text.isEmpty ||
                  _controller4.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
              } else {
                DataRepository.date.add(_controller1.text);
                SharedPreferences.getInstance().then( (sharedPrefs) {
                  sharedPrefs.setString("date", _controller1.text);
                } );
                DataRepository.StadiumIDnumber.add(_controller2.text);
                SharedPreferences.getInstance().then( (sharedPrefs) {
                  sharedPrefs.setString("StadiumIDnumber", _controller2.text);
                } );
                DataRepository.team1IDnumber.add(_controller3.text);
                SharedPreferences.getInstance().then( (sharedPrefs) {
                  sharedPrefs.setString("team1IDnumber", _controller3.text);
                } );
                DataRepository.team2IDnumber.add(_controller4.text);
                SharedPreferences.getInstance().then( (sharedPrefs) {
                  sharedPrefs.setString("team2IDnumber", _controller4.text);
                } );

                DataRepository.count++;

                // Return to the home screen
                Navigator.pushNamed(context, "/");
              }
            },
            child: Text("submit"),
          )
        ],
      ),
    );
  }

  alter() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: _controller1, decoration: const InputDecoration(labelText: "date")),
          TextField(controller: _controller2, decoration: const InputDecoration(labelText: "Stadium ID number")),
          TextField(controller: _controller3, decoration: const InputDecoration(labelText: "Team 1 ID number")),
          TextField(controller: _controller4, decoration: const InputDecoration(labelText: "Team 2 ID number")),

          // --- UPDATE BUTTON ---
          ElevatedButton(
            onPressed: () async {
              // Trim inputs to prevent whitespace-only saves
              if (_controller1.text.trim().isEmpty ||
                  _controller2.text.trim().isEmpty ||
                  _controller3.text.trim().isEmpty ||
                  _controller4.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: All fields are required')),
                );
                return;
              }

              // 1. Add data to global runtime lists
              DataRepository.date.add(_controller1.text);
              DataRepository.StadiumIDnumber.add(_controller2.text);
              DataRepository.team1IDnumber.add(_controller3.text);
              DataRepository.team2IDnumber.add(_controller4.text);
              DataRepository.count++;

              // 2. Safely sync the entire string lists to disk storage
              final sharedPrefs = await SharedPreferences.getInstance();
              await sharedPrefs.setStringList("date", DataRepository.date);
              await sharedPrefs.setStringList("StadiumIDnumber", DataRepository.StadiumIDnumber);
              await sharedPrefs.setStringList("team1IDnumber", DataRepository.team1IDnumber);
              await sharedPrefs.setStringList("team2IDnumber", DataRepository.team2IDnumber);

              // 3. Return to the list view safely
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("update"),
          ),

          // --- REMOVE BUTTON ---
          ElevatedButton(
            onPressed: () async {
              final int indexToRemove = DataRepository.count1;

              // Strict safety check: Ensure the index is valid across ALL 4 lists
              bool isIndexValid = indexToRemove >= 0 &&
                  indexToRemove < DataRepository.date.length &&
                  indexToRemove < DataRepository.StadiumIDnumber.length &&
                  indexToRemove < DataRepository.team1IDnumber.length &&
                  indexToRemove < DataRepository.team2IDnumber.length;

              if (isIndexValid) {
                // 1. Remove from runtime memory lists
                DataRepository.date.removeAt(indexToRemove);
                DataRepository.StadiumIDnumber.removeAt(indexToRemove);
                DataRepository.team1IDnumber.removeAt(indexToRemove);
                DataRepository.team2IDnumber.removeAt(indexToRemove);

                // Recalculate your global counter safely
                DataRepository.count = DataRepository.date.length;

                // 2. Persist the newly shortened lists to storage
                final sharedPrefs = await SharedPreferences.getInstance();
                await sharedPrefs.setStringList("date", DataRepository.date);
                await sharedPrefs.setStringList("StadiumIDnumber", DataRepository.StadiumIDnumber);
                await sharedPrefs.setStringList("team1IDnumber", DataRepository.team1IDnumber);
                await sharedPrefs.setStringList("team2IDnumber", DataRepository.team2IDnumber);

                // 3. Return to the previous screen safely
                if (context.mounted) Navigator.pop(context);
              } else {
                // Gracefully handle error visually instead of crashing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cannot remove: Index $indexToRemove is out of bounds.')),
                );
              }
            },
            child: const Text("remove"),
          )
        ],
      ),
    );
  }

}
class DataRepository{
  static int count =0;
  static List<String> date = [];
  static List<String> StadiumIDnumber = [];
  static List<String> team1IDnumber = [];
  static List<String> team2IDnumber = [];
  static int count1 =0;
  static bool trigger = false;
}
void functionName() async {
  final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
}
