import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = TextEditingController();
  List _listaDeDados = [];

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    File file = File("${diretorio.path}/info.json");
    //print(file.path);

    return file;
  }

  _salvarArquivo() async {
    File file = await _getFile();
    file.writeAsString(json.encode(_listaDeDados));
    print("O arquivo foi salvo");
    print(json.encode(_listaDeDados));
  }

  _salvarTarefa() async {
    String textoDigitado = _controller.text;
    Map<String, dynamic> tarefa = Map();

    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _listaDeDados.add(tarefa);
    });
    _salvarArquivo();
    _controller.text = "";
    Navigator.pop(context);
  }

  _recuperar() async {
    try {
      File file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    try{
      _recuperar().then((value) {
        setState(() {
          _listaDeDados = json.decode(value);
        });
      });
    }catch(e){
      print("Possivelmente o arquivo ainda nem existe");
    }
  }

  @override
  Widget build(BuildContext context) {
    _recuperar();
    bool _checkOption = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Salvar no celular"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: _listaDeDados.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: _listaDeDados[index]["realizada"] ?? false,
                onChanged: (checked){
                    print(checked.toString());
                    setState(() {
                      _checkOption = checked;
                      _listaDeDados[index]["realizada"] = checked;
                      _salvarArquivo();
                    });
                },
                title: Text("${_listaDeDados[index]["titulo"]}"),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar item"),
                    content: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Digite sua tarefa",
                      ),
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () => _salvarTarefa(),
                          child: Text("Salvar")),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _controller.text = "";
                          },
                          child: Text("Cancelar")),
                    ],
                  );
                });
          }),
    );
  }
}
