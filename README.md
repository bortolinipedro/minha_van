# Minha Van

Bem-vindo ao projeto **Minha Van**!

Este é um aplicativo completo para gestão de transporte escolar, desenvolvido por mim, Pedro Augusto Macari e meus colegas Eron Arthur da Silva e Bruno Carlos. Nosso objetivo é facilitar a vida de motoristas e passageiros (alunos), tornando o processo de cadastro, agendamento e comunicação mais simples, moderno e eficiente.

---

## Visão Geral

O Minha Van é um app multiplataforma (Flutter) que permite:
- Motoristas gerenciarem grupos de passageiros.
- Passageiros/alunos se cadastrarem, visualizarem horários e confirmarem presença.
- Interface intuitiva, responsiva e fiel ao design proposto no Figma.

---

## Autores
- **Pedro Augusto Macari**
- **Eron Arthur da Silva**
- **Bruno Carlos**

---

## Tecnologias Utilizadas
- **Flutter** (Dart) — para o desenvolvimento do front-end mobile.
- **Sqflite** — banco de dados local SQLite para persistência dos dados.
- **Figma** — para o design das telas.

---

## Estrutura do Projeto

```
minha_van_v2/
├── lib/
│   ├── main.dart                # Ponto de entrada do app
│   ├── screens/                 # Telas (cadastro, login, home, perfil, etc)
│   ├── widgets/                 # Componentes customizados (botões, appbar)
│   ├── constants/               # Cores, espaçamentos, estilos de texto
│   ├── helpers/                 # SQLHelper e utilitários
│   └── services/                # (Futuro) Serviços de autenticação/back-end
├── assets/                      # Imagens, ícones, fontes
├── pubspec.yaml                 # Dependências do projeto
└── README.md                    # Este arquivo
```

---

## Funcionalidades

### Para Motorista
- Cadastro e login de motorista
- Criação e gerenciamento de grupos de passageiros
- Visualização dos passageiros de cada grupo
- Edição de perfil

### Para Passageiro/Aluno
- Cadastro e login de passageiro
- Associação a grupos
- Visualização de horários de ida e volta
- Confirmação de presença
- Edição de perfil

### Gerais
- Interface moderna, responsiva e intuitiva
- Navegação fluida entre telas
- Persistência local dos dados

---

## Instalação e Execução

### Pré-requisitos
- Flutter SDK instalado ([veja como instalar](https://docs.flutter.dev/get-started/install))
- Android Studio, VSCode ou outro editor compatível

### Passos para rodar o projeto
1. Clone o repositório:
   ```bash
   git clone <url-do-repositorio>
   cd minha_van_v2
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Rode o app em um emulador ou dispositivo físico:
   ```bash
   flutter run
   ```

---

## Front-end

O front-end foi desenvolvido em Flutter, seguindo fielmente o design do Figma. Utilizamos componentes customizados para garantir consistência visual (cores, espaçamentos, fontes). As principais telas são:
- Tela de escolha (motorista ou passageiro)
- Cadastro e login
- Home (diferente para motorista e passageiro)
- Listagem de grupos
- Perfil
- Agendamento
- Sobre

Todas as telas usam navegação nomeada e estão conectadas via `MaterialApp` no `main.dart`.

---

## Back-end


---

## Como contribuir

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b minha-feature`)
3. Commit suas alterações (`git commit -am 'Minha feature'`)
4. Push para a branch (`git push origin minha-feature`)
5. Abra um Pull Request

---

Se tiver dúvidas, sugestões ou quiser contribuir, fique à vontade para entrar em contato!

**Pedro Augusto Macari, Eron Arthur da Silva e Bruno Carlos**
