import 'dart:io'; // Importa o pacote para manipulação de arquivos, necessário para trabalhar com imagens.
import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção da interface do usuário.
import 'package:image_picker/image_picker.dart'; // Importa o pacote para capturar imagens usando a câmera ou galeria.
import 'package:permission_handler/permission_handler.dart'; // Importa o pacote para verificar e solicitar permissões.
import 'package:controle_quilometragem_veiculo/database/db.dart'; // Importa a classe DB para operações no banco de dados.

/// Função que verifica e solicita a permissão para acessar a câmera.
Future<void> requestCameraPermissao(BuildContext context, Function(File?) onImagePicked) async {
  PermissionStatus status = await Permission.camera.status;

  // Se a permissão foi negada ou está restrita, solicita permissão
  if (status.isDenied || status.isRestricted) {
    status = await Permission.camera.request();
  }

  // Se a permissão foi concedida, chama a função para pegar a imagem
  if (status.isGranted) {
    pegarImage(context, onImagePicked);
  }
  // Se a permissão foi negada permanentemente, abre as configurações do aplicativo
  else if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
  // Caso contrário, exibe uma mensagem informando que a permissão foi negada
  else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissão de câmera negada')),
    );
  }
}

/// Função que abre a câmera do dispositivo e permite ao usuário tirar uma foto.
Future<void> pegarImage(BuildContext context, Function(File?) onImagePicked) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera); // Abre a câmera e espera que o usuário tire uma foto.

  // Se o usuário tirou uma foto, passa o arquivo para a função de callback.
  if (image != null) {
    onImagePicked(File(image.path));
  }
}

/// Função que carrega a lista de veículos armazenados no banco de dados.
Future<void> carregarVeiculo(Function(List<Map<String, dynamic>>) onLoad) async {
  try {
    final db = await DB.instance.database; // Obtém a instância do banco de dados.
    final List<Map<String, dynamic>> vehicles = await db.query('veiculosSalvos'); // Faz uma consulta para obter todos os veículos.
    onLoad(vehicles); // Passa a lista de veículos para a função de callback.
  } catch (e) {
    print('Erro ao carregar veículos: $e'); // Exibe um erro no console se ocorrer um problema ao carregar os veículos.
  }
}

/// Função que exclui um veículo do banco de dados após confirmação do usuário.
Future<void> excluirVeiculo(BuildContext context, int id, Function() onDelete) async {
  try {
    // Exibe um diálogo para confirmar a exclusão do veículo.
    final bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir este veículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Se o usuário confirmar, fecha o diálogo e retorna true.
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Se o usuário cancelar, fecha o diálogo e retorna false.
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );

    // Se o usuário confirmou, realiza a exclusão do veículo no banco de dados.
    if (confirm == true) {
      final db = await DB.instance.database;
      await db.delete(
        'veiculosSalvos',
        where: 'id = ?', // Especifica que o veículo a ser excluído é aquele com o ID correspondente.
        whereArgs: [id],
      );
      onDelete(); // Chama a função de callback para atualizar a interface após a exclusão.
    }
  } catch (e) {
    // Se ocorrer um erro durante a exclusão, exibe uma mensagem de erro.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao excluir veículo: $e')),
    );
  }
}
