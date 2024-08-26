import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção da interface do usuário.
import 'package:controle_quilometragem_veiculo/tela_inicial.dart'; // Importa a tela inicial do aplicativo.
import 'package:controle_quilometragem_veiculo/function/function.dart'; // Importa funções auxiliares.
import 'package:controle_quilometragem_veiculo/database/db.dart'; // Importa a classe DB para manipulação do banco de dados.
import 'dart:io'; // Importa a biblioteca Dart para manipulação de arquivos.

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  _TelaCadastroState createState() => _TelaCadastroState(); // Cria o estado para a tela de cadastro.
}

class _TelaCadastroState extends State<TelaCadastro> {
  File? _image; // Armazena a imagem capturada ou selecionada pelo usuário.
  final TextEditingController _viagemController = TextEditingController(); // Controlador para o campo de código da viagem.
  final TextEditingController _quilometragemController = TextEditingController(); // Controlador para o campo de quilometragem.
  final TextEditingController _motoristaController = TextEditingController(); // Controlador para o campo de nome do motorista.
  final TextEditingController _inicioController = TextEditingController(); // Controlador para o campo de cidade de início da viagem.
  final TextEditingController _destinoController = TextEditingController(); // Controlador para o campo de cidade de destino da viagem.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Configuração da barra de aplicativo.
        backgroundColor: const Color(0xff0077B6),
        automaticallyImplyLeading: false, // Impede o retorno automático à tela anterior.
        title: const Text(
          'Cadastro de veículos', // Título da tela.
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Centraliza o título na barra.
        leading: IconButton( // Botão para voltar à tela inicial.
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TelaInicial()), // Navega de volta para a tela inicial.
            );
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView( // Adiciona a capacidade de rolagem à tela.
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Define o espaçamento interno.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Alinha os filhos ao longo do eixo principal.
            children: [
              const SizedBox(height: 15), // Espaçamento vertical.
              GestureDetector( // Widget que detecta toques na área da imagem.
                onTap: () => requestCameraPermissao(context, (image) { // Solicita permissão para acessar a câmera.
                  setState(() {
                    _image = image; // Armazena a imagem selecionada.
                  });
                }),
                child: Container( // Contêiner para exibir a imagem ou uma mensagem de "Adicionar Foto".
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10), // Bordas arredondadas.
                    border: Border.all(color: Colors.grey), // Bordas cinza.
                  ),
                  child: _image == null
                      ? const Center(
                    child: Text(
                      'Adicionar Foto', // Texto exibido quando nenhuma imagem foi adicionada.
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                      : Image.file(
                    _image!, // Exibe a imagem selecionada.
                    fit: BoxFit.cover, // Ajusta a imagem para cobrir o contêiner.
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaçamento vertical.
              TextField(
                controller: _viagemController, // Controlador para o campo de código da viagem.
                decoration: const InputDecoration(
                  labelText: 'Código de viagem', // Texto de rótulo.
                  border: OutlineInputBorder(), // Estilo de borda.
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _quilometragemController,
                keyboardType: TextInputType.number, // Define o tipo de teclado para números.
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
                  // Verifica se todos os campos foram preenchidos e se uma imagem foi selecionada.
                  if (_image != null
                      || _viagemController != null
                      || _quilometragemController != null
                      || _motoristaController != null
                      || _inicioController != null
                      ||  _destinoController != null
                  ) {
                    final fotoPath = _image!.path; // Obtém o caminho da foto.
                    final viagem = _viagemController.text; // Obtém o código da viagem.
                    final quilometragem = double.tryParse(_quilometragemController.text) ?? 0.0; // Converte a quilometragem para double.
                    final motorista = _motoristaController.text; // Obtém o nome do motorista.
                    final inicio = _inicioController.text; // Obtém a cidade de início.
                    final destino = _destinoController.text; // Obtém a cidade de destino.

                    // Insere os dados no banco de dados.
                    await DB.instance.inserirVeiculo(viagem, quilometragem, motorista, inicio, destino, fotoPath);

                    Navigator.pop(context, true); // Volta para a tela anterior.
                  } else {
                    // Exibe uma mensagem de erro se algum campo não foi preenchido.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, preencha todos os campos e adicione uma foto')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0077B6), // Cor do botão.
                  iconColor: Colors.white, // Cor do ícone.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas.
                  ),
                ),
                child: const Text(
                  'Salvar Cadastro', // Texto do botão.
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
