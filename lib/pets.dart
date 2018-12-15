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
          leading: Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data[index]["fields"]["Photo URI"]["stringValue"])))),
          title: Text(data[index]["fields"]["Identifier"]["stringValue"]),
          subtitle: Text(data[index]["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"], style: TextStyle(color: Colors.grey)),
          onTap: (){
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => DetailScreen(pet: data, index: index,)
            ));
          },);
      }
    );

    }
  }

class DetailScreen extends StatelessWidget{
  DetailScreen({this.pet, this.index});
  final int index;
  final List pet;
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text(pet[index]["fields"]["Identifier"]["stringValue"]), automaticallyImplyLeading: true,) ,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(children: <Widget>[ 
            Container(width: 100, height: 100, margin: EdgeInsets.fromLTRB(5.0, 3.0, 0, 0), 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                image: DecorationImage(
                  fit: BoxFit.cover, 
                  image: NetworkImage(
                    pet[index]["fields"]["Photo URI"]["stringValue"]
                  )
                )
              )
            Container( 
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0), 
              child:Column( 
                children: <Widget>[ 
                  Text(pet[index]["fields"]["Identifier"]["stringValue"], ),
                  Text(pet[index]["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"])
                ]
              )
            )
          ], 
          )],
      )
      );
      
  }
}