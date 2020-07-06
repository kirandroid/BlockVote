import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

abstract class IConfigurationService {
  Future<void> setMnemonic(String value);
  Future<void> setupDone(bool value);
  Future<void> setPrivateKey(String value);
  Future<String> getMnemonic();
  Future<String> getPrivateKey();
  Future<bool> didSetupWallet();
  Future<bool> clearDB();
}

class ConfigurationService implements IConfigurationService {
  final storage = new FlutterSecureStorage();

  @override
  Future<void> setMnemonic(String value) async {
    String encryptionKey = await storage.read(key: "encryptedBoxKey");
    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();
    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);
    await encryptedBox.put("mnemonic", value);
  }

  @override
  Future<void> setPrivateKey(String value) async {
    String encryptionKey = await storage.read(key: "encryptedBoxKey");
    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();
    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);
    await encryptedBox.put("privateKey", value);
  }

  @override
  Future<void> setupDone(bool value) async {
    String encryptionKey = await storage.read(key: "encryptedBoxKey");

    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();
    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);
    await encryptedBox.put("didSetupWallet", value);
  }

  // gets
  @override
  Future<String> getMnemonic() async {
    String encryptionKey = await storage.read(key: "encryptedBoxKey");

    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();
    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);
    return encryptedBox.get('mnemonic');
  }

  @override
  Future<String> getPrivateKey() async {
    String encryptionKey = await storage.read(key: "encryptedBoxKey");

    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();
    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);
    return encryptedBox.get('privateKey');
  }

  @override
  Future<bool> didSetupWallet() async {
    String encryptionKey = await storage.read(key: "encryptedBoxKey");

    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();
    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);
    return encryptedBox.get('didSetupWallet') ?? false;
  }

  @override
  Future<bool> clearDB() async {
    bool hasClearedDB = false;
    String encryptionKey = await storage.read(key: "encryptedBoxKey");
    List<int> encryptionKeyList =
        (jsonDecode(encryptionKey) as List<dynamic>).cast<int>();

    var encryptedBox =
        await Hive.openBox('vaultBox', encryptionKey: encryptionKeyList);

    await encryptedBox.deleteFromDisk().then((value) {
      hasClearedDB = true;
    }).catchError((onError) {
      print(onError);
      hasClearedDB = false;
    });
    return hasClearedDB;
  }
}
