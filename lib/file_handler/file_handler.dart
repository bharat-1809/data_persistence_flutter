import 'dart:convert';
import 'dart:io';

import 'package:file_example/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  // Makes this a singleton class, as we want only want a single
  // instance of this object for the whole application
  FileHandler._privateConstructor();
  static final FileHandler instance = FileHandler._privateConstructor();

  static File? _file;

  static final _fileName = 'user_file.txt';

  // Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await _initFile();
    return _file!;
  }

  // Inititalize file
  Future<File> _initFile() async {
    final _directory = await getApplicationDocumentsDirectory();
    final _path = _directory.path;
    return File('$_path/$_fileName');
  }

  static Set<User> _userSet = {};

  Future<void> writeUser(User user) async {
    final File fl = await file;
    _userSet.add(user);

    // Now convert the set to a list as the jsonEncoder cannot encode
    // a set but a list.
    final _userListMap = _userSet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(_userListMap));
  }

  Future<List<User>> readUsers() async {
    final File fl = await file;
    final _content = await fl.readAsString();

    final List<dynamic> _jsonData = jsonDecode(_content);
    final List<User> _users = _jsonData
        .map(
          (e) => User.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return _users;
  }

  Future<void> deleteUser(User user) async {
    final File fl = await file;

    _userSet.removeWhere((e) => e == user);
    final _userListMap = _userSet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(_userListMap));
  }

  Future<void> updateUser({
    required int id,
    required User updatedUser,
  }) async {
    _userSet.removeWhere((e) => e.id == updatedUser.id);
    await writeUser(updatedUser);
  }
}
