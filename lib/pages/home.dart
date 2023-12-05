import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho1/pages/new_person.dart';
import 'package:trabalho1/pages/edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, String>> peopleList = [];

  Future<void> saveList() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> serializedList =
        peopleList.map((person) => jsonEncode(person)).toList();

    await prefs.setStringList('peopleList', serializedList);
  }

  Future<void> loadList() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? peopleListString = prefs.getStringList('peopleList');

    if (peopleListString != null) {
      setState(() {
        peopleList = peopleListString
            .map((person) => (jsonDecode(person) as Map<String, dynamic>)
                .map((key, value) => MapEntry(key, value.toString())))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of People',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 12, 102, 1),
      ),
      body: peopleList.isEmpty
          ? const Center(
              child: Text(
                'No people added yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: peopleList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        peopleList.removeAt(index);
                      });
                      saveList();
                    } else if (direction == DismissDirection.endToStart) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditExistingPerson(personData: peopleList[index]),
                        ),
                      ).then((newPerson) {
                        if (newPerson != null) {
                          setState(() {
                            peopleList[index] = newPerson;
                          });
                          saveList();
                          loadList();
                        }
                      });
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.yellow,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16.0),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(peopleList[index]['name'] ?? ''),
                    subtitle: Text(peopleList[index]['phone'] ?? ''),
                    trailing: Text(peopleList[index]['email'] ?? ''),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPerson = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPersonPage()),
          );

          if (newPerson != null) {
            setState(() {
              peopleList.add(newPerson);
            });
            await saveList();
          }
        },
        backgroundColor: const Color.fromRGBO(0, 12, 102, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
