import 'package:flutter/material.dart'; // Importa o pacote Flutter para criar a interface do usuário.
import 'package:controle_quilometragem_veiculo/function/function.dart'; // Importa as funções reutilizáveis que lidam com operações no banco de dados.
import 'package:controle_quilometragem_veiculo/cadastrar_veiculo.dart'; // Importa a tela de cadastro de veículos.
import 'dart:io'; // Importa o pacote Dart para manipulação de arquivos.

/// [TelaInicial] é um [StatefulWidget] que representa a tela inicial do aplicativo.
/// Exibe a lista de veículos cadastrados e permite a exclusão de veículos.
class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

/// [_TelaInicialState] gerencia o estado da tela inicial, incluindo a
/// lista de veículos carregados do banco de dados.
class _TelaInicialState extends State<TelaInicial> {
  List<Map<String, dynamic>> _veiculos = []; // Armazena a lista de veículos carregados.

  @override
  void initState() {
    super.initState();
    _carregarVeiculos(); // Carrega os veículos ao iniciar a tela.
  }

  /// [_carregarVeiculos] carrega a lista de veículos do banco de dados.
  Future<void> _carregarVeiculos() async {
    await carregarVeiculo((veiculos) {
      setState(() {
        _veiculos = veiculos; // Atualiza o estado com a lista de veículos.
      });
    });
  }

  /// [_excluirVeiculo] exclui um veículo do banco de dados com base no ID.
  Future<void> _excluirVeiculo(int id) async {
    await excluirVeiculo(context, id, _carregarVeiculos); // Exclui o veículo e recarrega a lista.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0077B6), // Define a cor de fundo da AppBar.
        automaticallyImplyLeading: false, // Remove o botão de voltar automático.
        title: const Text(
          'Controle de quilometragem de veículos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Centraliza o título.
      ),
      body: _veiculos.isEmpty
          ? const Center(
        child: Text('Nenhum veículo cadastrado'), // Exibe mensagem se não houver veículos.
      )
          : ListView.builder(
        itemCount: _veiculos.length, // Define a quantidade de itens na lista.
        itemBuilder: (context, index) {
          final veiculo = _veiculos[index];
          return Card(
            margin: const EdgeInsets.all(10.0), // Define a margem do card.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200, // Define a altura da imagem.
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Define o arredondamento das bordas.
                    image: DecorationImage(
                      image: FileImage(File(veiculo['foto'])), // Carrega a imagem do arquivo.
                      fit: BoxFit.cover, // Ajusta a imagem para cobrir o espaço disponível.
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
                          _excluirVeiculo(veiculo['id']); // Exclui o veículo quando o botão é pressionado.
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, // Cor do texto do botão.
                          backgroundColor: Colors.white, // Cor de fundo do botão.
                          side: BorderSide(color: Colors.grey), // Cor da borda do botão.
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
            MaterialPageRoute(builder: (context) => const TelaCadastro()), // Navega para a tela de cadastro.
          );
        },
        backgroundColor: const Color(0xff0077B6), // Define a cor do botão flutuante.
        tooltip: 'Adicionar Veículo', // Tooltip exibida ao passar o cursor sobre o botão.
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
