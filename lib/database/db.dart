import 'package:sqflite/sqflite.dart'; // Importa o pacote sqflite para manipulação de banco de dados SQLite.
import 'package:path/path.dart'; // Importa o pacote path para manipulação de caminhos de arquivos.

class DB {
  DB._(); // Construtor privado para a classe DB, implementando o padrão Singleton.

  static final DB instance = DB._(); // Instância única da classe DB, garantindo que apenas uma instância seja criada.

  static Database? _database; // Variável estática para armazenar a instância do banco de dados.

  /// Método que retorna a instância do banco de dados.
  /// Se o banco de dados já foi criado, ele o retorna, caso contrário, o inicializa.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  /// Método privado que inicializa o banco de dados.
  /// Ele cria ou abre o banco de dados no caminho especificado.
  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'quilometragem.db'), // Define o caminho do banco de dados.
      version: 1, // Define a versão do banco de dados.
      onCreate: _onCreate, // Define a função a ser chamada quando o banco de dados for criado.
    );
  }

  /// Método chamado quando o banco de dados é criado pela primeira vez.
  /// Ele executa o comando SQL para criar a tabela `veiculosSalvos`.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_veiculosSalvos); // Executa a criação da tabela.
  }

  /// Comando SQL para criar a tabela `veiculosSalvos`.
  String get _veiculosSalvos => '''
  CREATE TABLE veiculosSalvos(
    id INTEGER PRIMARY KEY AUTOINCREMENT, // Chave primária, valor autoincremental.
    viagem VARCHAR(500), // Coluna para armazenar o código da viagem.
    quilometragem DOUBLE, // Coluna para armazenar a quilometragem.
    motorista VARCHAR(200), // Coluna para armazenar o nome do motorista.
    destino VARCHAR(500), // Coluna para armazenar a cidade de destino.
    inicio VARCHAR(500), // Coluna para armazenar a cidade de início.
    foto VARCHAR(500) // Coluna para armazenar o caminho da foto.
  );
''';

  /// Método para inserir um veículo na tabela `veiculosSalvos`.
  /// Recebe os parâmetros correspondentes às colunas da tabela.
  Future<void> inserirVeiculo(String viagem, double quilometragem, String motorista, String inicio, String destino, String fotoPath) async {
    final db = await _database; // Obtém a instância do banco de dados.
    await db!.insert('veiculosSalvos', { // Insere um novo veículo no banco de dados.
      'viagem': viagem, // Código da viagem.
      'quilometragem': quilometragem, // Quilometragem da viagem.
      'motorista': motorista, // Nome do motorista.
      'inicio': inicio, // Cidade de início da viagem.
      'destino': destino, // Cidade de destino da viagem.
      'foto': fotoPath, // Caminho da foto.
    });
  }
}
