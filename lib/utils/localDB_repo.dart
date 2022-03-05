import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LocalDBRepo {

	// Making this class Singleton
	static final LocalDBRepo _singleton = LocalDBRepo._internal();

	factory LocalDBRepo() {
		return _singleton;
	}
	LocalDBRepo._internal();

	late Database _db;

	Database get db {
		return _db;
	}

	final Logger _log = Logger("LocalDBRepo");

	Future<bool> init({bool forceRebuild = false}) async {
		bool newDB = false;
		if (Platform.isWindows || Platform.isLinux) {
			// Initialize FFI
			sqfliteFfiInit();
			// Change the default factory
			databaseFactory = databaseFactoryFfi;
		}

		String path = await _getDBDirectoryPath();
		if(forceRebuild) await deleteDb(path);

		await openDatabase(
			path,
			version: 1,
			onOpen: (db) {
				_db = db;
				print("Opening the existing DB $path");
				getLocalDBTableList();
			},
			onCreate: (Database db, int version) async {
				print("Creating a new local DB at path $path");
				_db = db;
				await createTables(db);
				await getLocalDBTableList();
				newDB = true;
			},

		);


		return newDB;
	}

	Future<void> deleteDb(String path) async {
		print("deleting db at $path");
		await deleteDatabase(path);
	}

	Future<void> clearDb() async {
		await db.delete("ORGANIZATION");
		await db.delete("CUSTOMER");
		await db.delete("CUSTOMER_PRODUCT");
		await db.delete("ESTIMATE");
		await db.delete("INVOICE");
		await db.delete("PAYMENT");
		await db.delete("PRODUCT");
		await db.delete("CHALLAN");
	}

	Future<String> _getDBDirectoryPath() async {
		Directory documentsDirectory = await getApplicationDocumentsDirectory();
		return join(documentsDirectory.path, "minierp.db");
	}

// 	Future<int> insertParam(String key, String value) async {
// 		return _db.insert('PARAM', {'key': key, 'value': value},
// 			conflictAlgorithm: ConflictAlgorithm.replace);
// 	}
//
// 	Future<int> insertDeviceInfo(String deviceId, String deviceName) async {
// 		return _db.insert('DEVICE', {'device_id': deviceId, 'name': deviceName},
// 			conflictAlgorithm: ConflictAlgorithm.replace);
// 	}
//
// 	Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
// 		final Future<List<Map<String, dynamic>>> futureMaps = _db.query(tableName);
// 		return await futureMaps;
// 	}
//
// 	Future<List<String>> fetchDeviceInfo() async {
// 		List<Map<String, dynamic>> dataMap = await _db.query('DEVICE');
// 		List<String> info = List();
// 		if(dataMap !=null && dataMap.length > 0) {
// 			info[0] = dataMap[0]['device_id'];
// 			info[1]  = dataMap[0]['name'];
// 		}
//
// 		return info;
// 	}
//
// 	Future<Map<String, dynamic>> fetchParams() async {
// 		List<Map<String, dynamic>> dataMap = await _db.query('PARAM');
// 		Map<String, dynamic> params = Map();
// 		dataMap.forEach((param) =>
// 		{
// 			params[param['key']] = param['value']
// 		});
//
// 		return params;
// 	}
//
// 	//========================
//
// 	Future<int> insertUnitCategory(String type, String label) async {
// 		return _db.insert('UNIT_CATEGORY', {'type': type, 'label': label},
// 			conflictAlgorithm: ConflictAlgorithm.replace);
// 	}
//
// 	Future<List<Map<String, dynamic>>> fetchUnitCategory() async {
// 		List<Map<String, dynamic>> dataMap = await _db.query('UNIT_CATEGORY');
// 		Map<String, dynamic> params = Map();
// 		return dataMap;
// 	}
//
// 	Future<int> insertUnit(String type, String unit, String label) async {
// 		return _db.insert('UNIT', {'type': type, "unit": unit, 'label': label},
// 			conflictAlgorithm: ConflictAlgorithm.replace);
// 	}
//
// 	Future<Map<String, Map<String, Units>>> fetchUnit() async {
// 		Map<String, Map<String, Units>> units = Map();
// 		List<Map<String, dynamic>> dataMap = await _db.query('UNIT');
// 		try {
// 			dataMap.forEach((unit) {
// 				int id = unit['id'];
// 				String type = unit['type'];
// //        _log.fine("type is $type");
// 				if (!units.containsKey(type)) {
// 					units[type] = Map<String, Units>();
// //          _log.fine("creating a new map for  $type");
// 				}
// 				Map<String, Units> unitsMap = units[type];
// 				String unitValue = unit['unit'].toString();
// 				unitsMap[unitValue] = Units(unit: unitValue, label: unit['label']);
// 			});
// //      _log.fine("before returning");
// 		} catch (e) {
// 			_log.fine("Error is $e");
// 		}
// 		return units;
// 	}
//
//
	Future<int> insertOrganization(String name, String address, int pin, String city, String logo) async {
		return _db.insert('ORGANIZATION', {'name': name, 'address': address, 'PIN' : pin, 'city' : city, 'logo' : logo},
			conflictAlgorithm: ConflictAlgorithm.replace);
	}
//
// 	Future<List<Map<String, dynamic>>> fetchValidValue() async {
// 		final Future<List<Map<String, dynamic>>> futureMaps = _db.query('VALID_VALUE');
// 		return await futureMaps;
// 	}
//
// 	Future<int> insertVVitem(String type, String key, String label) async {
// 		return _db.insert('VALID_VALUE_ITEM', {'type': type, "key": key, 'label': label},
// 			conflictAlgorithm: ConflictAlgorithm.replace);
// 	}
//
// 	Future<Map<String, List<ValidValue>>> fetchVVItem() async {
// 		List<Map<String, dynamic>> dataMap = await _db.query('VALID_VALUE_ITEM');
// 		Map<String, List<ValidValue>> validValues = Map();
// 		dataMap.forEach((vv) {
// 			String type = vv['type'];
// 			if (!validValues.containsKey(type)) {
// 				validValues[type] = List<ValidValue>();
// 			}
// 			List<ValidValue> vvList = validValues[type];
// 			vvList.add(ValidValue(key: vv['key'], label: vv['label']));
// 		});
//
// 		return validValues;
// 	}

//	Future<String> fetchParam(String key) async {
//
//		final Future<List<Map<String, dynamic>>> futureMaps = _db.query('PARAM', where: 'key = ?', whereArgs: [key]);
//		var maps = await futureMaps;
//
//		if (maps.length != 0) {
//			return (maps.first)['value'];
//		}
//		return null;
//	}

	Future<List<dynamic>> getLocalDBTableList() async {
		List<dynamic> tableNames =
		(await _db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
			.map((row) => row['name'] as String)
			.toList(growable: false);

   print("table names : $tableNames");
		return tableNames;
	}

	Future<void> createTables(Database db) async {
		print("started creating db tables");
		await db.execute("CREATE TABLE PRODUCT ("
			"id INTEGER PRIMARY KEY,"
			"name TEXT,"
			"unit TEXT,"
			"HSN TEXT,"
			"GST TEXT,"
			"ACTIVE TINYINT(1)"
			")");

		await db.execute("CREATE TABLE CHALLAN ("
				"id INTEGER PRIMARY KEY,"
				"challan_no TEXT,"
				"customer_name TEXT,"
				"product_id INT,"
				"product_name TEXT,"
				"price_per_unit REAL,"
				"quantity REAL,"
				"total_amount REAL,"
				"invoice_number TEXT,"
				"active TINYINT(1)"
				")");

		await db.execute("CREATE TABLE ORGANIZATION ("
			"id INTEGER PRIMARY KEY,"
			"name TEXT,"
			"Contact_person TEXT,"
			"address TEXT,"
			"PIN INTEGER,"
			"city TEXT,"
			"state TEXT,"
			"GST TEXT,"
			"PAN TEXT,"
			"logo TEXT"
			")");

		await db.execute("CREATE TABLE CUSTOMER ("
			"id INTEGER PRIMARY KEY AUTOINCREMENT,"
			"company_name TEXT,"
			"contact_person TEXT,"
			"contact_phone TEXT  ,"
			"address TEXT,"
			"PIN INTEGER,"
			"city TEXT,"
			"state TEXT,"
			"state_cd TEXT,"
			"GST TEXT,"
			"credit_period INTEGER,"
			"active TINYINT(1)"
			")");

		// await db.execute("CREATE TABLE PRODUCT ("
		// 		"id INTEGER PRIMARY KEY,"
		// 		"name TEXT,"
		// 		"unit TEXT," //(Liters, KG etc)
		// 		"HSN TEXT,"
		// 		"GST TEXT,"
		// 		"active TINYINT(1)"
		// 		")");

		print("completed creating db tables");
		// await db.execute("CREATE TABLE CHALLAN ("
		// 	"id INTEGER PRIMARY KEY AUTOINCREMENT,"
		// 	"challan_number INTEGER UNIQUE,"
		// 	"customer_id INTEGER"
		// 	")");
		//
		// await db.execute("CREATE TABLE UNIT ("
		// 	"id INTEGER PRIMARY KEY AUTOINCREMENT,"
		// 	"type TEXT,"
		// 	"unit String,"
		// 	"label TEXT"
		// 	")");
		//
		// await db.execute("CREATE TABLE DEVICE ("
		// 	"device_id TEXT PRIMARY KEY,"
		// 	"name TEXT"
		// 	")");
	}
}

// enum TableNames { PARAM, VALID_VALUE, VALID_VALUE_ITEM, UNIT_CATEGORY, UNIT }
