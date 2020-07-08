import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/imovel.dart';

void main() {
  runApp(Aplicacao());
}

class Aplicacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:  'Aplicacao Imobiliaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
    ),
    home: PaginaHome(),
    );
  }
}

class PaginaHome extends StatefulWidget {
  var imoveis = new List<Imovel>();

  PaginaHome(){
    imoveis = [];
    /*imoveis.add(Imovel(title: 'Imóvel 1', available: true));
    imoveis.add(Imovel(title: 'Imóvel 2', available: true));
    imoveis.add(Imovel(title: 'Imóvel 3', available: false));*/


  }

  @override
  _PaginaHomeState createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  var newTaskCtrl = TextEditingController();

  void add(){
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.imoveis.add(
        Imovel(
          title: newTaskCtrl.text,
          available: false,
        ),
      );
      newTaskCtrl.text = ''; //ou
      newTaskCtrl.clear();
      save();
    });
  }

  void remove(int index){
    setState(() {
      widget.imoveis.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if(data != null){
      Iterable decoded = jsonDecode(data);
      List<Imovel> result = decoded.map((x) => Imovel.fromJson(x)).toList();
      setState(() {
        widget.imoveis = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.imoveis));
  }

  _PaginaHomeState(){
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            labelText: 'Novo imóvel',
            labelStyle: TextStyle(
                color: Colors.white)
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.imoveis.length,
        itemBuilder: (BuildContext ctxt, int index){
          final imovel = widget.imoveis[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(imovel.title),
              value: imovel.available,
              onChanged: (value){
                setState(() {
                  imovel.available = value;
                  save();
                });
              },
            ),
            key: Key(imovel.title),
            background: Container(
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction){
              print(direction);
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}