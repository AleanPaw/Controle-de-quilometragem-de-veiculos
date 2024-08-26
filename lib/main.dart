import 'package:flutter/material.dart'; // Importa o pacote Flutter, que contém widgets essenciais para criar interfaces de usuário.
import 'package:controle_quilometragem_veiculo/tela_inicial.dart'; // Importa a tela inicial do aplicativo, onde será exibido o conteúdo principal.

/// Função principal do aplicativo que é executada ao iniciar o app.
/// A função `main` é o ponto de entrada do aplicativo Flutter.
void main() {
  runApp(const MyApp()); // Inicia o aplicativo e chama o widget raiz `MyApp`.
}

/// [MyApp] é o widget raiz do aplicativo.
/// Extende de [StatelessWidget], o que significa que não tem estado interno que mude durante a execução.
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Construtor constante da classe `MyApp`.

  @override
  Widget build(BuildContext context) {
    // O método `build` é chamado para construir a interface do usuário deste widget.
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Desativa a exibição da bandeira de debug no canto superior direito.
      home: TelaInicial(), // Define `TelaInicial` como a tela inicial (ou principal) do aplicativo.
    );
  }
}
