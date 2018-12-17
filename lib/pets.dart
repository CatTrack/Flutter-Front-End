import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'auth.dart' as auth;
import 'globals.dart' as global;


class PetList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _PetListState();
  
}

class _PetListState extends State<PetList>{
  @override
  void initState(){
    super.initState();
    this._getCats(false);
  }

  List data;

  //Stream<List<Object>> catList = api.Api().getCats(); 

  Future<String>_getCats(bool user) async{
    String user = await auth.Auth().currentUser();
    var url = "https://us-central1-te-cattrack.cloudfunctions.net/getCatsAdv?userID=$user";
    if(global.data == null || user == true){
      print("loading");
      print(global.data);
      var catResponse = await http.get(url);
      setState(() {
          var resbody = json.decode(catResponse.body);
          data = resbody["documents"];
    }); 
      global.data = data;
    }
    else{
      print("Got from global");
      var catResponseinstant = global.data;
      setState(() {
              data = catResponseinstant;
      });
    }

    
    
    
    return "success";
  }

  Widget _pushAddCatScreen(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context){
          return Scaffold(
            appBar: AppBar(automaticallyImplyLeading: true, title: Text("Add cat"),),
            body: Form(
              child: Column(
                children: <Widget>[

                ]
              ),
            ),
          );
        }
      )
    );
  }

  Widget _catItemBuilder(context, index){
    if(index.length == 0){
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
    return Scaffold(
    body: ListView.separated(
      itemCount: global.data == null ? 0 : global.data.length,

      separatorBuilder: (context, index){
        return Divider();
      },
      itemBuilder: (context, int index) {
        global.allowedOut.add(true);
        return ListTile(
          leading: Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(global.data[index]["fields"]["Photo URI"]["stringValue"])
              )
            )
          ),
          title: Text(global.data[index]["fields"]["Identifier"]["stringValue"]),
          subtitle: Text(global.data[index]["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"], style: TextStyle(color: Colors.grey)),
          onTap: (){
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => DetailScreen(pet: global.data, index: index)
                )
              );
            },
          );
      }
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _pushAddCatScreen,
      tooltip: "Add task",
      child: Icon(Icons.add)
    ),
    );
    }
  }

class DetailScreen extends StatefulWidget{
  DetailScreen({this.pet, this.index});
  final int index;
  final List pet;
  //List allowedOut;


  @override
  State<StatefulWidget> createState() => DetailScreenState();

}
class DetailScreenState extends State<DetailScreen>{

  void updateSwitch(bool value) => setState(() { 
    global.allowedOut.insert(widget.index, value);
    //global.data[widget.index]["fields"]["allowedOut"].insert("booleanValue", value);
    //http.put(url)
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text(widget.pet[widget.index]["fields"]["Identifier"]["stringValue"]), automaticallyImplyLeading: true,
      actions: <Widget>[IconButton(
        icon: Icon(Icons.edit),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
            builder: (context) => EditScreen(pet: global.data, index: widget.index, ),
          )
          );
          
        }  ,
      ),
      ],
      ) ,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[ 
            Container(width: 100, height: 100, margin: EdgeInsets.fromLTRB(5.0, 3.0, 0, 0), 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                image: DecorationImage(
                  fit: BoxFit.cover, 
                  image: NetworkImage(
                    widget.pet[widget.index]["fields"]["Photo URI"]["stringValue"]
                  )
                )
              )
            ),
            Container( 
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0), 
              child:Column( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ 
                  Text(widget.pet[widget.index]["fields"]["Identifier"]["stringValue"], style: TextStyle(fontSize: 24.0), textAlign: TextAlign.end,),
                  Text("${widget.pet[widget.index]["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"]} - ${widget.pet[widget.index]["fields"]["Location"]["mapValue"]["fields"]["Specific Location"]["arrayValue"]["values"][0]["mapValue"]["fields"]["Specific Location"]["mapValue"]["fields"]["Location Identifier"]["stringValue"]}", style: TextStyle( color: Colors.grey, fontSize: 16.0),)
                ]
              )
            )
          ],
          ),
          SwitchListTile(
            value: global.allowedOut.elementAt(widget.index),
            title: Text("Allowed outside?"),
            onChanged: updateSwitch,
          )
          ],
      )
      );
      
  }
}

class EditScreen extends StatefulWidget{
  EditScreen({this.pet, this.index});
  final int index;
  final List pet;

  @override
  State<StatefulWidget> createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen>{
  void updateSwitch(bool value) => setState(() { 
    global.allowedOut.insert(widget.index, value);
  });

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( automaticallyImplyLeading: true, title: Text(widget.pet[widget.index]["fields"]["Identifier"]["stringValue"]),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector( 
              child: Container(width: 100, height: 100, margin: EdgeInsets.fromLTRB(5.0, 3.0, 0, 0), 
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  
                  image: DecorationImage(
                    fit: BoxFit.cover, 
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                    image: NetworkImage(
                      widget.pet[widget.index]["fields"]["Photo URI"]["stringValue"]
                    )
                  )
                ),
              

                child: Icon(Icons.image, color: Colors.white, size: 50,),
                
              ) 
              ),
            Container( 
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0), 
              child:Column( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ 
                  Text(widget.pet[widget.index]["fields"]["Identifier"]["stringValue"], style: TextStyle(fontSize: 24.0), textAlign: TextAlign.end,),
                  Text("${widget.pet[widget.index]["fields"]["Location"]["mapValue"]["fields"]["General Location"]["stringValue"]} - ${widget.pet[widget.index]["fields"]["Location"]["mapValue"]["fields"]["Specific Location"]["arrayValue"]["values"][0]["mapValue"]["fields"]["Specific Location"]["mapValue"]["fields"]["Location Identifier"]["stringValue"]}", style: TextStyle( color: Colors.grey, fontSize: 16.0),)
                ]
              )
            )
          ],
          ),
          SwitchListTile(
            value: global.allowedOut.elementAt(widget.index),
            title: Text("Allowed outside?"),
            onChanged: updateSwitch,
          )
          ],
    ),
    );
  }
}

