import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaDeTarefas = [];

  _salvarArquivo() async{
     final diretorio = await getApplicationDocumentsDirectory();
     var arquivo = File(diretorio.path + "/dados.json");

     //Criar Dados
     Map<String, dynamic> tarefa = Map();
     tarefa["titulo"] = "Ir ao mercado";
     tarefa["realizada"] = false;

     _listaDeTarefas.add(tarefa);

     arquivo.writeAsString(json.encode(_listaDeTarefas));
  }


  @override
  Widget build(BuildContext context) {
    _salvarArquivo();
    return Scaffold(
      appBar: AppBar(title: Text("Lista de tarefas"),),
      body: ListView.builder(
        itemCount: _listaDeTarefas.length,
          itemBuilder: (context, index){
              return ListTile(
                 title: Text(_listaDeTarefas[index]),
              );
          }
          ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
              context: context,
             builder: (context){
                return AlertDialog(
                  title: Text("Adcionar tarefa"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Digite sua tarefa",
                    ),
                    onChanged: (text){},
                  ),
                  actions: [
                     FlatButton(onPressed: (){}, child: Text("Salvar")),
                     FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),
                  ],
                );
             }
          );
        },
      ),

    );
  }
}
