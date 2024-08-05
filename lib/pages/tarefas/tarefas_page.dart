import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/tarefas_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TarefasPage extends StatefulWidget {
  TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final db = FirebaseFirestore.instance;

  String userId = '';
  final descricaoController = TextEditingController();

  var apenasNaoConcluidos = false;

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  void carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          descricaoController.text = '';
          showDialog(
            context: context,
            builder: (BuildContext bc) {
              return AlertDialog(
                title: const Text('Adicionar Tarefa'),
                content: TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    hintText: 'Digite a descrição da tarefa',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var tarefa = TarefasModel(
                        descricao: descricaoController.text,
                        concluido: false,
                        userId: userId,
                      );
                      db.collection("tarefas").add(tarefa.toJson()).then(
                          (DocumentReference doc) => print(
                              'DocumentSnapshot added with ID: ${doc.id}'));
                      Navigator.pop(context);
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tarefas",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: apenasNaoConcluidos,
                  onChanged: (bool value) {
                    apenasNaoConcluidos = value;
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: apenasNaoConcluidos
                    ? db
                        .collection("tarefas")
                        .where('concluido', isEqualTo: false)
                        .snapshots()
                    : db.collection("tarefas").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      var tarefa = TarefasModel.fromJson(
                        (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>),
                      );
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: tarefa.concluido,
                              onChanged: (value) {
                                tarefa.concluido = value!;
                                tarefa.dataAlteracao = DateTime.now();
                                db
                                    .collection("tarefas")
                                    .doc(snapshot.data!.docs[index].id)
                                    .update(tarefa.toJson());
                              },
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                tarefa.descricao,
                                style: TextStyle(
                                  decoration: tarefa.concluido
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                db
                                    .collection("tarefas")
                                    .doc(snapshot.data!.docs[index].id)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
