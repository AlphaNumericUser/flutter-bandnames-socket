import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

List<Band> bands = [];

@override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen:  false);
    socketService.socket.on('bandas-activas', _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload ){

    bands = (payload as List).map(
        (banda) => Band.fromMap(banda)
      ).toList();
      setState(() {});

  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen:  false);
    socketService.socket.off('bandas-activas');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Corriditos Tumbados'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: ( socketService.serverStatus == ServerStatus.online )
                ? Icon(Icons.check_circle_rounded, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red[400])
          ),
        ],
      ),
      body: Column(
        children: [

          _showGraph(),

          const SizedBox(height: 10,),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) {
                return _bandTile( bands[index] );
              },
            ),
          ),


        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible( // ! <--- Este widget es para deslizar y borrar las listas
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) {
        socketService.socket.emit('delete-band', { 'id':band.id });
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
          socketService.socket.emit('vote-band', { 'id':band.id });
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', { 'name': name });
    }
    Navigator.pop(context);

  }

  _showGraph() {
  Map<String, double> dataMap = {};

  for (var banda in bands) {
    dataMap[banda.name] = banda.votes.toDouble();
  }

  // Verificar si dataMap no está vacío antes de crear el gráfico
  if (dataMap.isNotEmpty) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: PieChart(
        dataMap: dataMap,
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false
        ),
      ),
    );
  } else {
    // En caso de que dataMap esté vacío, puedes manejarlo de acuerdo a tus necesidades
    // Por ejemplo, mostrar un mensaje de que no hay datos para mostrar.
    return const SizedBox();
  }
}


}