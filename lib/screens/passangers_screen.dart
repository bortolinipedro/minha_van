import 'package:flutter/material.dart';

/// Widget principal que inicializa o MaterialApp com o tema e a página inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grupos de Passageiros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GruposPassageirosPage(), // Página inicial do app
    );
  }
}

/// Tela com os grupos de passageiros organizados em botões coloridos.
class GruposPassageirosPage extends StatelessWidget {
  // Lista de grupos com nomes e cores personalizadas em hexadecimal.
  final List<Map<String, dynamic>> grupos = [
    {'nome': 'Grupo da Manhã', 'cor': const Color(0xFF8E97FD)},
    {'nome': 'Grupo da Tarde', 'cor': const Color(0xFFFA6E5A)},
    {'nome': 'Grupo da Noite PUC', 'cor': const Color(0xFF515763)},
    {'nome': 'Grupo Sábado Natação', 'cor': const Color(0xFF7EB1BF)},
    {'nome': 'Grupo Sábado Casamento', 'cor': const Color(0xFFD6A5D2)},
    {'nome': 'Grupo Batizado', 'cor': const Color(0xFFA2E0C1)},
  ];

  GruposPassageirosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold cria a estrutura visual da tela com appBar e corpo
      appBar: AppBar(
        title: const Text(
          'Grupos de passageiros',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context); // Volta à tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento da borda
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha um grupo para visualizar',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16), // Espaçamento entre texto e grade
            Expanded(
              child: GridView.builder(
                // Grid com 2 colunas para exibir os grupos como botões
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3, // Ajuste de tamanho visual das caixas
                ),
                itemCount: grupos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Ao clicar, navega para a tela de detalhes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GrupoDetalhesPage(
                                grupoNome: grupos[index]['nome'],
                                grupoCor: grupos[index]['cor'],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: grupos[index]['cor'],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          grupos[index]['nome'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tela de detalhes para o grupo selecionado.
class GrupoDetalhesPage extends StatelessWidget {
  final String grupoNome;
  final Color grupoCor;

  const GrupoDetalhesPage({
    super.key,
    required this.grupoNome,
    required this.grupoCor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(grupoNome), backgroundColor: grupoCor),
      body: Center(
        child: Text(
          'Detalhes do grupo $grupoNome',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
