import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'auth.dart' as auth;


class PetList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _PetListState();
  
}

class _PetListState extends State<PetList>{
  @override
  void initState(){
    super.initState();
    this._getCats();
  }

  List data;

  //Stream<List<Object>> catList = api.Api().getCats(); 

  Future<String>_getCats() async{
    String user = await auth.Auth().currentUser();
    var url = "https://us-central1-te-cattrack.cloudfunctions.net/getCatsAdv?userID=$user";
    var catResponse = await http.get(url);
    
    setState(() {
          var resbody = json.decode(catResponse.body);
          data = resbody["documents"];
    }); 
    return "success";
  }

  Widget _catItemBuilder(context, index){
    if(index == null){
      return Text("Loading...");
    }
    else{
     return ListTile(
          leading: Image.network(index["fields"]["Photo URI"], fit: BoxFit.cover,),
          title: Text(index["fields"]["Identifier"]["stringValue"]),
          subtitle: Text(index["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"],style: TextStyle(color: Colors.grey),));
    }
  }

  @override
  Widget build(BuildContext context){
    
    int count = 0;
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, int index) {
        print(data[index]);
        return ListTile(
          title: Text(data[index]["fields"]["Identifier"]["stringValue"]),
          subtitle: Text(data[index]["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"], style: TextStyle(color: Colors.grey)),
          onTap: (){
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => DetailScreen(petName: data[index]["fields"]["Identifier"]["stringValue"])
            ));
          },);
      }
    );

    }
  }

class DetailScreen extends StatelessWidget{
  DetailScreen({this.petName});
  final String petName;
  
  @override
  Widget build(BuildContext context){
    print(petName);
    return Scaffold(
      appBar: AppBar(title:Text(petName), automaticallyImplyLeading: true,) ,
      body: Center(child: Text("hi"),)
      );
      
  }
}