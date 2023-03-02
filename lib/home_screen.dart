import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivedbproject/boxes/box.dart';
import 'package:hivedbproject/model/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Hive Database')),
      ),
      body: ValueListenableBuilder<Box<NotesModels>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModels>();
          return ListView.builder(
            itemCount: box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data[index].title.toString(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                delete(data[index]);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _editDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString());
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Text(
                          data[index].description.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      )

      /*  Column(
        children: const [
            FutureBuilder(
            future: Hive.openBox('ali'),
            builder: (context, snapshot) {
              return Column(
                children: [
                  ListTile(
                    title: Text(snapshot.data!.get('name').toString()),
                    subtitle: Text(snapshot.data!.get('age').toString()),
                    trailing: IconButton(
                        onPressed: () {
                          snapshot.data!.put('name', 'youtube');
                          snapshot.data!.delete('age');
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                ],
              );
            },
          ) 
        ],
      ),*/
      ,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          //  var box = await Hive.openBox('ali');
          //   box.put("name", 'ijaz');
          //  box.put('age', 23);
          //  box.put('detail', {'pro': 'opp', 'country': 'pakistan'});
          // print(box.get('name'));
          _showMyDialog();
        },
      ),
    );
  }

  void delete(NotesModels notesModels) async {
    await notesModels.delete();
  }

  Future<void> _editDialog(
      NotesModels notesModels, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder()),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancl")),
            TextButton(
                onPressed: () {
                  notesModels.title = titleController.text.toString();
                  notesModels.description =
                      descriptionController.text.toString();
                  notesModels.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text("Edit")),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(" Add Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Enter Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder()),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  final data = NotesModels(
                      title: titleController.text,
                      description: descriptionController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                  print(box);
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text("Add"))
          ],
        );
      },
    );
  }
}
