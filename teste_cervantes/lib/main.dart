import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'user.dart';
import 'databaseUser.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MaterialApp(home: UserScreen()));
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<User> Users = [];

  final codUserController = TextEditingController();
  final nameController = TextEditingController();
  
  User? selectedUser;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    final list = await DatabaseUser.instance.readAllUsers();
    setState(() => Users = list);
  }

  void clean() {
    codUserController.clear();
    nameController.clear();
    selectedUser = null;
  }
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  void saveUser() async {
    final name = nameController.text.trim();
    final coduser = codUserController.text.trim();

    if (name.isEmpty || coduser.isEmpty) {
      showMessage('Preencha todos os campos.');
      return;
    }

    final codUser = int.tryParse(coduser);
    if (codUser == null || codUser <= 0) {
      showMessage('Código deve ser um número válido.');
      return;
    }

    try {
      if (selectedUser == null) {
        // Verificar se já existe usuário com esse codUser
        final existingUser = await DatabaseUser.instance.readByCodUser(codUser);
        if (existingUser != null) {
          showMessage('Já existe um usuário com esse código.');
          return;
        }

        await DatabaseUser.instance.create(User(codUser: codUser, name: name));
      } else {
        await DatabaseUser.instance.update(
          User(codUser: selectedUser!.codUser, name: name),
        );
      }

      clean();
      loadUsers();
    } catch (e) {
      showMessage('Erro: ${e.toString()}');
    }
  }


  void updateUser(User User) {
    codUserController.text = User.codUser.toString();
    nameController.text = User.name;
    setState(() => selectedUser = User);
  }

  void deleteUser(int codUser) async {
    await DatabaseUser.instance.delete(codUser);
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuários')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: codUserController,
            decoration: InputDecoration(labelText: 'Código do Usuário'),
            keyboardType: TextInputType.number,
            enabled: selectedUser == null
          ),
          TextField(
            controller: nameController, decoration: InputDecoration(labelText: 'Nome')
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: saveUser,
            child: Text(selectedUser == null ? 'Add' : 'Update'),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: Users.length,
              itemBuilder: (context, index) {
              final user = Users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text('Código: ${user.codUser}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => updateUser(user),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteUser(user.codUser!),
                    ),
                  ],
                ),
              );
            },
            ),
          ),
        ]),
      ),
    );
  }
  
}