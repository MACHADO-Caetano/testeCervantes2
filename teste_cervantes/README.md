# Teste 2 Cervantes

# 📱 Aplicativo Flutter: Cadastro de Usuários com Logs (SQLite)

Este projeto é um aplicativo Flutter que permite realizar **cadastros de usuários**, utilizando um banco de dados local SQLite. Toda operação de **CRUD (Create, Read, Update, Delete)** é registrada automaticamente em uma tabela de **logs**, garantindo rastreabilidade das ações realizadas.

---

## ✅ Funcionalidades

- Cadastro de usuários com:
  - `codUser` (inteiro, único, obrigatório, maior que zero)
  - `name` (texto, obrigatório, não vazio)
- Visualização da lista de usuários cadastrados
- Edição e exclusão de usuários
- Registro automático de logs de cada operação com data/hora e tipo de ação

---

## 📦 Estrutura do Banco de Dados

A aplicação utiliza **dois bancos locais SQLite**, via `sqflite_common_ffi`:

### `users.db`
Contém a tabela de cadastro:

```sql
CREATE TABLE users (
  codUser INTEGER PRIMARY KEY CHECK (codUser > 0),
  name TEXT NOT NULL CHECK (LENGTH(name) > 0)
);
```
### `logs.db`
Contém a tabela de logs:

```sql
CREATE TABLE logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  operation TEXT NOT NULL,
  timestamp TEXT NOT NULL
);
```

## 🛡️ Validações
As validações são implementadas em duas camadas:

💻 No Código (Flutter)
Todos os campos são obrigatórios.

codUser deve ser numérico e maior que 0.

Verifica se o codUser já existe antes de inserir um novo.

🗄️ No Banco de Dados (SQLite)
codUser → CHECK (codUser > 0)

name → CHECK (LENGTH(name) > 0)

NOT NULL para garantir presença dos dados

## ▶️ Como Executar o Projeto
Pré-requisitos
Flutter instalado

VSCode, Android Studio ou outro IDE

SDK para desktop (Linux, macOS, Windows) ou emulador

# Clone o repositório
```
git clone https://github.com/MACHADO-Caetano/testeCervantes2.git
cd testeCervantes2/teste_cervantes
```
# Instale as dependências
```
flutter pub get
```
# Rode a aplicação
```
flutter run -d windows # ou macos/linux conforme seu SO
```

## 📂 Organização do Projeto

teste_cervantes/
│
├── lib/
│   ├── main.dart           # Tela principal e lógica da interface
│   ├── user.dart           # Modelo de dados do usuário
│   └── databaseUser.dart   # Gerenciador do banco de dados (users.db + logs.db)
│
└── README.md               # Documentação do projeto


## 🤝 Autor
Desenvolvido por Caetano Machado


