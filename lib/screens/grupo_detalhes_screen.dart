import 'package:flutter/material.dart';

/// Página que mostra os detalhes de um grupo, com abas "Vai Hoje" e "Volta Hoje"
class GrupoDetalhesPage extends StatefulWidget {
  final String grupoNome; // Nome do grupo
  final Color grupoCor; // Cor associada ao grupo

  const GrupoDetalhesPage({
    super.key,
    required this.grupoNome,
    required this.grupoCor,
  });

  @override
  /// Cria o estado associado à página `GrupoDetalhesPage`.
  ///
  /// Este método sobrescreve o método `createState` da classe `StatefulWidget`
  /// e retorna uma instância de `_GrupoDetalhesPageState`, que gerencia o estado
  /// e o comportamento da página de detalhes do grupo.
  State<GrupoDetalhesPage> createState() => _GrupoDetalhesPageState();
}

/// / Estado associado à página `GrupoDetalhesPage`.
///
class _GrupoDetalhesPageState extends State<GrupoDetalhesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controlador para as abas

  @override
  void initState() {
    super.initState();
    // Inicia o TabController com 2 abas
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Libera recursos quando a tela for destruída
    super.dispose();
  }

  // Lista de passageiros fixa para as duas abas
  final List<Map<String, String>> passageiros = [
    {
      'nome': 'Maria', // Nome do passageiro
      'endereco': 'Av. Barbacena - Barro Preto', // Endereço do passageiro
      'telefone': '(31) 9 1111-1111', // Telefone do passageiro
    },
    {
      'nome': 'Pedro',
      'endereco': 'Av. Rio Grande do Norte - Savassi',
      'telefone': '(31) 9 1111-1111',
    },
    {
      'nome': 'João Antônio',
      'endereco': 'R. Santa Rita Durão - Funcionários',
      'telefone': '(31) 9 1111-1111',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usa um Stack para fazer a barra superior com layout customizado
      body: Column(
        children: [
          Container(
            height: 160, // Altura da barra superior
            color: widget.grupoCor, // Cor da barra superior
            child: SafeArea(
              child: Stack(
                children: [
                  // Botão de voltar
                  Positioned(
                    left: 16, // Posição à esquerda
                    top: 16, // Posição no topo
                    child: CircleAvatar(
                      backgroundColor: Colors.white, // Cor de fundo do botão
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ), // Ícone do botão
                        onPressed: () {
                          Navigator.pop(context); // Volta para a tela anterior
                        },
                      ),
                    ),
                  ),
                  // Botão de download
                  Positioned(
                    right: 16, // Posição à direita
                    top: 16, // Posição no topo
                    child: CircleAvatar(
                      backgroundColor: Colors.black26, // Cor de fundo do botão
                      child: IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ), // Ícone do botão
                        onPressed: () {
                          // ação de download
                        },
                      ),
                    ),
                  ),
                  // Título centralizado
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centraliza verticalmente
                      children: [
                        Text(
                          widget.grupoNome, // Nome do grupo
                          style: const TextStyle(
                            color: Colors.white, // Cor do texto
                            fontSize: 24, // Tamanho da fonte
                            fontWeight: FontWeight.w500, // Peso da fonte
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Abas "Vai Hoje" e "Volta Hoje"
          TabBar(
            controller: _tabController, // Controlador das abas
            labelColor: const Color(
              0xFF4C4C63,
            ), // Cor do texto da aba selecionada
            unselectedLabelColor:
                Colors.grey[400], // Cor do texto das abas não selecionadas
            indicatorColor: const Color(
              0xFF4C4C63,
            ), // Cor do indicador da aba selecionada
            tabs: const [
              Tab(text: "VAI HOJE"), // Aba "Vai Hoje"
              Tab(text: "VOLTA HOJE"), // Aba "Volta Hoje"
            ],
          ),
          // Conteúdo das abas
          Expanded(
            child: TabBarView(
              controller: _tabController, // Controlador das abas
              children: [
                _buildListaPassageiros(), // Conteúdo da aba "Vai Hoje"
                _buildListaPassageiros(), // Conteúdo da aba "Volta Hoje"
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a lista com os passageiros
  Widget _buildListaPassageiros() {
    return ListView.separated(
      itemCount: passageiros.length, // Número de itens na lista
      separatorBuilder:
          (context, index) =>
              const Divider(height: 1), // Separador entre os itens
      itemBuilder: (context, index) {
        final passageiro = passageiros[index]; // Dados do passageiro atual
        return ListTile(
          title: Text(
            '${passageiro['nome']} | ${passageiro['endereco']}',
          ), // Nome e endereço do passageiro
          subtitle: Text('${passageiro['telefone']}'), // Telefone do passageiro
        );
      },
    );
  }
}
