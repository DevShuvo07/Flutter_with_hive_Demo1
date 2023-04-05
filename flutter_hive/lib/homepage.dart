import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes/boxes.dart';
import 'package:flutter_hive/models/notes_models.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final titleController = TextEditingController();
  final desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hive Database"),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<NotesModels>>(
          valueListenable: Boxes.getData().listenable(), 
          builder: (context, box, _){
            var data = box.values.toList().cast<NotesModels>();
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),),
                            const Spacer(),
                            InkWell(
                              onTap: (){
                                delete(data[index]);
                              },
                              child: const Icon(Icons.delete, color: Colors.red,)
                            ),
                            const SizedBox(width: 15,),
                            InkWell(
                              onTap: (){
                                _UpdateDialog(data[index], data[index].title.toString(), data[index].description.toString());

                              },
                              child: const Icon(Icons.edit)
                            ),
                          ],
                        ),
                        Text(data[index].description.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
                );
              }
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            _showMyDialog();
          },
          child: const Icon(Icons.add),
          ),
          
      );
  }

  void delete(NotesModels notesModels) async{
    await notesModels.delete();
  }

  Future<void> _UpdateDialog( NotesModels notesModels, String title, String Description) async{
    titleController.text = title;
    desController.text = Description;
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text('Edit Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Title"
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: desController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Description'
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                // final data = NotesModels(title: titleController.text, description: desController.text);
                // final box = Boxes.getData();
                // box.add(data);
                //data.save();
                notesModels.title = titleController.text.toString();
                notesModels.description = desController.text.toString();
                notesModels.save();
                titleController.clear();
                desController.clear();
                
                Navigator.pop(context);
              }, 
              child: const Text('Edit')
            ),
            TextButton(
              onPressed: (){
                titleController.clear();
                desController.clear();
                Navigator.pop(context);
              }, 
              child: const Text('cancel')
            )
          ],
        );
      }
    );
  }

  Future<void> _showMyDialog() async{
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text('Add Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Title"
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: desController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Description'
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                final data = NotesModels(title: titleController.text, description: desController.text);
                final box = Boxes.getData();
                box.add(data);
                data.save();
                titleController.clear();
                desController.clear();
                
                Navigator.pop(context);
              }, 
              child: const Text('Add')
            ),
            TextButton(
              onPressed: (){
                titleController.clear();
                desController.clear();
                Navigator.pop(context);
              }, 
              child: const Text('cancel')
            )
          ],
        );
      }
    );
  }
}