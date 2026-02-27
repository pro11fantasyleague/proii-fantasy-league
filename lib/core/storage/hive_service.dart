import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String boxLeagues = 'leagues_box';
  static const String boxTeam = 'team_box';
  static const String boxSettings = 'settings_box';

  /// Initialisation au démarrage de l'app
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxLeagues);
    await Hive.openBox(boxTeam);
    await Hive.openBox(boxSettings);
  }

  /// Sauvegarder des données (On stocke souvent en JSON String pour éviter les adapters complexes au début)
  Future<void> saveData(String boxName, String key, Map<String, dynamic> value) async {
    final box = Hive.box(boxName);
    await box.put(key, jsonEncode(value));
  }

  Future<void> saveList(String boxName, String key, List<dynamic> list) async {
    final box = Hive.box(boxName);
    await box.put(key, jsonEncode(list));
  }

  /// Lire des données
  Map<String, dynamic>? getData(String boxName, String key) {
    final box = Hive.box(boxName);
    final String? data = box.get(key);
    if (data == null) return null;
    return jsonDecode(data);
  }

  List<dynamic>? getList(String boxName, String key) {
    final box = Hive.box(boxName);
    final String? data = box.get(key);
    if (data == null) return null;
    return jsonDecode(data);
  }

  /// Vérifier si des données existent (pour le mode offline)
  bool hasData(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.containsKey(key);
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }
}
