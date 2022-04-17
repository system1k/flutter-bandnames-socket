import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Coldplay', votes: 10),
    Band(id: '2', name: 'Linkin Park', votes: 8),
    Band(id: '3', name: 'All American Rejects', votes: 2),
    Band(id: '4', name: 'Queen', votes: 5)
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: _addNewBand
      ),
    );
  }  
  
  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: _background(),
      onDismissed: (direction){},
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: (){}
      ),
    );
  }

  _background() {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text('Delete Band', style: TextStyle(color: Colors.white))
      ),
    );
  }

  _addNewBand(){

    final textController = TextEditingController();

    if(Platform.isAndroid) {
      // Android
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController
            ),
            actions: [

              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                child: const Text('Add'),
                onPressed: () => _addBandToList(textController.text)
              )

            ],
          );
        }
      );  
    } else {
      // iOS
      return showCupertinoDialog(
        context: context, 
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [

              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => _addBandToList(textController.text)
              ),

              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context)
              )

            ],
          );
        }
      );
    }
    
  }

  void _addBandToList(String name){
    
    if (name.length > 1) {
      setState(
        () => bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0))
      );
    }

    Navigator.pop(context);
  } 

}