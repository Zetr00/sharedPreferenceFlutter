import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class Car {
  int id;
  String brand;
  String model;

  Car(this.id, this.brand, this.model);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      map['id'],
      map['brand'],
      map['model'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> cars = [];
  TextEditingController idController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cars';
    final carsJson = cars.map((car) => car.toMap()).toList();
    prefs.setStringList(key, carsJson.map((json) => jsonEncode(json)).toList());
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cars';
    final carsJson = prefs.getStringList(key) ?? [];

    setState(() {
      cars = carsJson.map((json) => Car.fromMap(Map<String, dynamic>.from(jsonDecode(json)))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: idController,
                    decoration: InputDecoration(labelText: 'ID'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: brandController,
                    decoration: InputDecoration(labelText: 'Brand'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: modelController,
                    decoration: InputDecoration(labelText: 'Model'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cars.add(Car(
                        int.parse(idController.text),
                        brandController.text,
                        modelController.text,
                      ));
                      saveData();
                    });
                  },
                  child: Text('Add Car'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('ID: ${cars[index].id}, Brand: ${cars[index].brand}, Model: ${cars[index].model}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
