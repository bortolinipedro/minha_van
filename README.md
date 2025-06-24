# Minha Van

Aplicativo de gerenciamento de vans para motoristas e passageiros.


## 📱 Visão Geral

O **Minha Van** é um app multiplataforma feito em Flutter que permite:

- Motoristas gerenciarem grupos de passageiros.
- Passageiros visualizarem horários e se associarem a grupos.

---

## 👨‍💻 Autores

- **Pedro Bortolini**
- **Eron Arthur da Silva**
- **Bruno Carlos**

---

## 🔐 Configuração de Segurança

### ⚠️ IMPORTANTE: Chaves do Firebase

Este projeto usa Firebase Authentication. **NUNCA** commite as seguintes chaves no repositório:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

### 🔧 Como configurar as chaves

1. **Crie um projeto no Firebase Console**
   - Acesse [Firebase Console](https://console.firebase.google.com/)
   - Crie um novo projeto ou use um existente

2. **Configure o Android**
   - No Firebase Console, adicione um app Android
   - Baixe o arquivo `google-services.json`
   - Coloque em `android/app/google-services.json`

3. **Configure o iOS** (quando necessário)
   - No Firebase Console, adicione um app iOS
   - Baixe o arquivo `GoogleService-Info.plist`
   - Coloque em `ios/Runner/GoogleService-Info.plist`

4. **Configure o Flutter**
   - Execute: `flutterfire configure`
   - Isso gerará o arquivo `lib/firebase_options.dart`

### 📁 Arquivos que devem ser ignorados

O `.gitignore` já está configurado para ignorar:
- Arquivos de configuração do Firebase
- Chaves de API
- Arquivos de keystore
- Configurações locais
- Arquivos temporários

## 🚀 Como executar

1. **Instale as dependências**
   ```bash
   flutter pub get
   ```

2. **Configure o Firebase** (veja seção acima)

3. **Execute o app**
   ```bash
   flutter run
   ```
---
```text
minha_van_v2/
├── lib/                      📁 Código principal do app
│   ├── main.dart            📄 Ponto de entrada principal 🧠
│   ├── screens/             📁 Telas da aplicação 🖥️
│   ├── widgets/             📁 Componentes reutilizáveis 🧩
│   ├── constants/           📁 Cores, espaçamentos, estilos 🎨
│   ├── helpers/             📁 SQLHelper e utilitários 🛠️
│   └── services/            📁 (Futuro) Serviços de back-end 🔌
├── assets/                  📁 Imagens, ícones e fontes 🖼️
├── pubspec.yaml             📄 Dependências e configs do Flutter 📦
└── README.md                📄 Documentação principal 📘
```
---

## 📱 Funcionalidades

- **Autenticação**: Login, registro e recuperação de senha
- **Perfil do usuário**: Edição de informações pessoais
- **Gerenciamento de grupos**: Para motoristas
- **Agendamento**: Para passageiros
- **Interface responsiva**: Design moderno e intuitivo

## 🛠️ Tecnologias

- **Flutter**: Framework de desenvolvimento
- **Firebase Auth**: Autenticação de usuários
- **SQLite**: Banco de dados local
- **Material Design**: Interface do usuário

## 📄 Licença

MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.
