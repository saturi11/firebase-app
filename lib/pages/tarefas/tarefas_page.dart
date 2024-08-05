import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/tarefas_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String userId = '';
  final TextEditingController descricaoController = TextEditingController();
  bool apenasNaoConcluidos = false;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        backgroundColor: Colors.teal, // Consistente com o tema do app
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          descricaoController.clear();
          showDialog(
            context: context,
            builder: (BuildContext bc) {
              return AlertDialog(
                title: const Text('Adicionar Tarefa'),
                content: TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(
                    hintText: 'Digite a descrição da tarefa',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
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
                      await db.collection("tarefas").add(tarefa.toJson());
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.teal, // Consistente com o tema do app
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.teal, // Consistente com o tema do app
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: Colors.teal, // Consistente com o tema do app
                  ),
                ),
                Switch(
                  value: apenasNaoConcluidos,
                  onChanged: (bool value) {
                    setState(() {
                      apenasNaoConcluidos = value;
                    });
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
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>,
                      );
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
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
                              onChanged: (bool? value) {
                                tarefa.concluido = value ?? false;
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
                                  fontSize: 16.0,
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
