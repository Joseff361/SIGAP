import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(TextEditApp());

class TextEditApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: new TextScreen()
    );
  }
}
class TextScreen extends StatefulWidget{
  @override
  _TextScreenState createState() => _TextScreenState();
}


// Primera pantalla
class _TextScreenState extends State<TextScreen> {

  String _texto = '\n\nCodigo de alumno';
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto SIGAP'),  
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _texto,
              style: new TextStyle(
              fontSize: 15.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF212121),
              fontWeight: FontWeight.bold,
              ),
            ),
            TextField(controller: _controller),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Buscar'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditScreen(_controller.text),
                ));
              },
            ),
          ],
        ),
      )
    );
  }
}


//Segunda Pantalla
class EditScreen extends StatefulWidget {
  final String texto;
  EditScreen(this.texto);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  // TextEditingController _controller;

  // Map data;
  List usersData;

  getUsers(String codigo) async{
    http.Response response = await  http.get('https://sigapdev2-consultarecibos-back.herokuapp.com/recaudaciones/alumno/concepto/listar_cod/' 
      + codigo);
    setState((){
      usersData = json.decode(response.body);
      debugPrint(response.body);
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    // _controller = TextEditingController(text: widget.texto);
    this.getUsers(widget.texto);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de pagos'),  
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: usersData == null ? 0 : usersData.length,
        itemBuilder: (BuildContext context, int index){
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage('https://images.emojiterra.com/twitter/v13.0/512px/1f393.png')),
                Text(
                  "  Fecha: ${usersData[index]["fecha"]}" + 
                  "\n  Concepto: ${usersData[index]["concepto"]}" +
                  "\n  Descripcion: ${usersData[index]["descripcion_recaudacion"]}" +
                  "\n  Numero: ${usersData[index]["numero"]}",
                  style: TextStyle(fontSize: 11)
                ),
                Spacer(),
                Text(
                  "S/.${usersData[index]["importe"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),  
        );
        },
      ) 
    );
  }
}