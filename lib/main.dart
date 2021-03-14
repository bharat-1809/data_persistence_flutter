import 'package:file_example/db_handler/db_handler.dart';
import 'package:file_example/file_handler/file_handler.dart';
import 'package:file_example/models/user_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DB Demo',
      home: MyHomePage(title: 'Flutter DB Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHandler db = DatabaseHandler.instance;
  final FileHandler fileHandler = FileHandler.instance;
  List<User> userList = [];

  final User user1 = User(
    id: 1,
    email: 'abc@example.com',
    name: 'Ram',
    phone: '1234567890',
    userAddress: Address(
      houseNo: '613',
      locality: 'RNT',
      city: 'Agartala',
      state: 'Tripura',
    ),
  );

  final User user2 = User(
    id: 2,
    email: 'def@gmail.com',
    name: 'Shyam',
    phone: '9876543210',
    userAddress: Address(
      houseNo: '128',
      locality: 'RNT Block-2',
      city: 'Agartala',
      state: 'Tripura',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // final _users = await db.getUsers();
                    final _users = await fileHandler.readUsers();
                    setState(() {
                      userList = _users;
                    });
                  },
                  child: Text('Get Users'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // await db.insert(user1);
                    // await db.insert(user2);
                    await fileHandler.writeUser(user1);
                    await fileHandler.writeUser(user2);
                  },
                  child: Text('Insert Users'),
                ),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    User _userUpdate = User(
                      id: user1.id,
                      email: user1.email,
                      name: 'Lakhan',
                      phone: user1.phone,
                      userAddress: user1.userAddress,
                    );

                    // await db.update(
                    //   user: _userUpdate,
                    //   whereColName: colId,
                    //   argument: user1.id,
                    // );
                    await fileHandler.updateUser(id: _userUpdate.id, updatedUser: _userUpdate);
                  },
                  child: Text('Update User'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // await db.delete(whereColName: colId, argument: user1.id);
                    await fileHandler.deleteUser(user1);
                  },
                  child: Text('Delete User'),
                ),
                const Spacer(),
              ],
            ),
            const Spacer(),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: userList.map((e) => Text(e.toString())).toList(),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
