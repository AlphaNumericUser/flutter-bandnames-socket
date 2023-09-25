import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

List<Band> bands = [
  Band(id: '1', name: 'La Arrolladora', votes: 5),
  Band(id: '2', name: 'Banda MS', votes: 4),
  Band(id: '3', name: 'El recodo', votes: 3),
  Band(id: '4', name: 'Los recoditos', votes: 2),
  Band(id: '5', name: 'Fuerza Regida', votes: 1),
]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands Names'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {

          return _bandTile( bands[index] );

        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible( // ! <--- Este widget es para deslizar y borrar las listas
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        // * Llamar el borrado en el server
        print('id: ${band.id}');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band', style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring(0,2) ),
        ),
        title: Text( band.name ),
        trailing: Text('${ band.votes }', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        onTap: () {
          
        },
      ),
    );
  }

  addNewBand(){

    final textController = TextEditingController();
  //* Android
    if( !Platform.isAndroid ){
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => addBandToList( textController.text ),
                child: const Text('Add'),
              )
            ],
          );
        },
      );
    }

  showCupertinoDialog(
    context: context, 
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('New band names'),
        content: CupertinoTextField(
          controller: textController,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Dismiss'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add'),
            onPressed: () => addBandToList( textController.text ),
          ),
        ],
      );
    },
  );

  }
  
  void addBandToList( String name ){

    if(name.length > 1){
      //Podemos Agregar
      bands.add( Band(id: DateTime.now().toString(), name: name, votes: 0) );
      setState(() {
        
      });
    }
    Navigator.pop(context);

  }
}