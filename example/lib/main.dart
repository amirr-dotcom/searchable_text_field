import 'package:example/cities_data_jsonj.dart';
import 'package:example/model/city.dart';
import 'package:flutter/material.dart';
import 'package:searchable_text_field/searchable_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(title: 'Searchable Text Field'),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() {
    cites=List<City>.from(cities.map((e) => City.fromJson(e)));
    setState(() {

    });
  }


  List<City> cites=[];

  List<City> searchedCities=[];

  TextEditingController controller=TextEditingController();

  City? selectedCity;
  bool loading =false;

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:     SearchableTextField<City>(
            controller: controller,
            // maintain status
            status: controller.text.trim().isEmpty?
            SearchableTextFieldStatus.none :
            selectedCity!=null?
            SearchableTextFieldStatus.itemSelected :
            loading?
            SearchableTextFieldStatus.loading :
            searchedCities.isEmpty?
            SearchableTextFieldStatus.noItemFound :
            searchedCities.isNotEmpty?
            SearchableTextFieldStatus.itemFound :
            SearchableTextFieldStatus.none,
            menuOption: MenuOption(
            ),
            decoration: const InputDecoration(
              hintText: "Search City Here",
            ),
            onChanged: (val) {
              if(val!=null){
                // you get the text change here
                // search or change data according to your need

                selectedCity=null;
                searchedCities.clear();
                searchedCities.addAll(cites
                    .where((element) =>
                    element.city.toString().toLowerCase().contains(val.toString().toLowerCase())).toList());
                setState(() {

                });
              }
            },
            onSelectedItem: (City city){
              // you will get selected city here
              selectedCity=city;
              setState(() {

              });
            },
            validator: (val) {
              if(val==null || val.toString().isEmpty){
                return "Required Field !!";
              }
              else if(selectedCity==null){
                return "Please Select Farmer";
              }
              else {
                return null;
              }
            },
            items: searchedCities.map((e) =>
                SearchableItem<City>(
                    value: e,
                    title: (e.city??""),
                style: const TextStyle(
                  color: Colors.blue
                ),)
            ).toList(),
          ),
        ),
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
