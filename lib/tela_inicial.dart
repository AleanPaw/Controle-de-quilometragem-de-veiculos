import 'package:flutter/material.dart';
import 'package:controle_quilometragem_veiculo/function/function.dart';
import 'package:controle_quilometragem_veiculo/cadastrar_veiculo.dart';
import 'dart:io';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Map<String, dynamic>> _veiculos = [];

  @override
  void initState() {
    super.initState();
    _carregarVeiculos();
  }

  Future<void> _carregarVeiculos() async {
    await carregarVeiculo((veiculos) {
      setState(() {
        _veiculos = veiculos;
      });
    });
  }

  Future<void> _excluirVeiculo(int id) async {
    await excluirVeiculo(context, id, _carregarVeiculos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0077B6),
        automaticallyImplyLeading: false,
        title: const Text(
          'Controle de quilometragem de veículos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _veiculos.isEmpty
          ? const Center(
               child: Text('Nenhum veículo cadastrado'),
          )
          : ListView.builder(
            itemCount: _veiculos.length,
            itemBuilder: (context, index) {
            final veiculo = _veiculos[index];
            return Card(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(veiculo['foto'])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Código viagem: ${veiculo['viagem']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Nome do motorista: ${veiculo['motorista']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Quilometragem que será rodada: ${veiculo['quilometragem']} km',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Cidade de início de viagem: ${veiculo['inicio']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Cidade de destino de viagem: ${veiculo['destino']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _excluirVeiculo(veiculo['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey),
                          ),
                          child: const Text('Excluir'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaCadastro()),
          );
        },
        backgroundColor: const Color(0xff0077B6),
        tooltip: 'Adicionar Veículo',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
