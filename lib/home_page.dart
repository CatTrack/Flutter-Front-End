import 'package:flutter/material.dart';
import 'auth.dart';
import 'pets.dart';
import 'globals.dart' as global;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';


class HomePage extends StatefulWidget{
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 1;

  void _signOut() async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e){
      print(e);
    }
  }

  void _onItemTapped(int index){
      setState(() {
        _selectedIndex = index;
      });
    }

  @override
  Widget build(BuildContext context){
    final FirebaseStorage storage = FirebaseStorage(
      storageBucket: "gs://te-cattrack.appspot.com",
    );
    
    final _widgetOptions = [
      Text('Index 0: Detectors'),
      PetList(storage: storage,),
      Text(global.data.toString())
    ];

    

    return Scaffold(
      appBar: AppBar( 
        title: Text("Cat Track"),
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: _signOut,
            )
        ],
      ),
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.nfc), title: Text("Detectors") ),
          BottomNavigationBarItem(icon: Icon(Icons.pets), title: Text("Pets")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings"))
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
      
  }
}