import 'package:flutter/material.dart';
import 'package:controle_quilometragem_veiculo/tela_inicial.dart';
import 'package:controle_quilometragem_veiculo/function/function.dart';
import 'package:controle_quilometragem_veiculo/database/db.dart';
import 'dart:io';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  File? _image;
  final TextEditingController _viagemController = TextEditingController();
  final TextEditingController _quilometragemController = TextEditingController();
  final TextEditingController _motoristaController = TextEditingController();
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0077B6),
        automaticallyImplyLeading: false,
        title: const Text(
          'Cadastro de veículos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TelaInicial()),
            );
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => requestCameraPermissao(context, (image) {
                  setState(() {
                    _image = image;
                  });
                }),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Text(
                            'Adicionar Foto',
                            style: TextStyle(color: Colors.black54),
                          ),
                  )
                      : Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _viagemController,
                decoration: const InputDecoration(
                  labelText: 'Código de viagem',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _quilometragemController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quilometragem',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _motoristaController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Motorista',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _inicioController,
                decoration: const InputDecoration(
                  labelText: 'Cidade de início de viagem',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _destinoController,
                decoration: const InputDecoration(
                  labelText: 'Cidade de destino de viagem',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_image != null
                      || _viagemController != null
                      || _quilometragemController != null
                      || _motoristaController != null
                      || _inicioController != null
                      ||  _destinoController != null
                  ) {
                    final fotoPath = _image!.path;
                    final viagem = _viagemController.text;
                    final quilometragem = double.tryParse(_quilometragemController.text) ?? 0.0;
                    final motorista = _motoristaController.text;
                    final inicio = _inicioController.text;
                    final destino = _destinoController.text;

                    await DB.instance.inserirVeiculo(viagem, quilometragem, motorista, inicio, destino, fotoPath);

                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, preencha todos os campos e adicione uma foto')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0077B6),
                  iconColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Salvar Cadastro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
