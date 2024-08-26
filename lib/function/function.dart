import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:controle_quilometragem_veiculo/database/db.dart';

// Função para verificar e solicitar permissão de câmera
Future<void> requestCameraPermissao(BuildContext context, Function(File?) onImagePicked) async {
  PermissionStatus status = await Permission.camera.status;

  if (status.isDenied || status.isRestricted) {
    // Solicita permissão
    status = await Permission.camera.request();
  }

  if (status.isGranted) {

    pegarImage(context, onImagePicked);
  } else if (status.isPermanentlyDenied) {

    await openAppSettings();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissão de câmera negada')),
    );
  }
}

// Função para abrir a câmera e pegar uma foto
Future<void> pegarImage(BuildContext context, Function(File?) onImagePicked) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    onImagePicked(File(image.path));
  }
}

// Função para carregar veículos
Future<void> carregarVeiculo(Function(List<Map<String, dynamic>>) onLoad) async {
  try {
    final db = await DB.instance.database;
    final List<Map<String, dynamic>> vehicles = await db.query('veiculosSalvos');
    onLoad(vehicles);
  } catch (e) {
    print('Erro ao carregar veículos: $e');
  }
}

// Função para excluir veículo
Future<void> excluirVeiculo(BuildContext context, int id, Function() onDelete) async {
  try {
    final bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir este veículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final db = await DB.instance.database;
      await db.delete(
        'veiculosSalvos',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao excluir veículo: $e')),
    );
  }
}
