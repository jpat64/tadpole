// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tadpole/controllers/TodayController.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  final GlobalKey<FormState> _key = GlobalKey();

  TodayController controller = TodayController();

  List<String>? inputs;
  String? newInput;

  @override
  void initState() {
    super.initState();
    inputs = List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tadpole"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              const Text("Welcome to Tadpole!"),
              TextFormField(onChanged: (value) {
                setState(() {
                  newInput = value;
                });
              }),
              ElevatedButton(
                onPressed: () async {
                  if (newInput != null && inputs != null) {
                    inputs!.add(newInput!);
                  }
                  //await controller.storeInputs(inputs);
                  //List<String>? tempInputs = await controller.getInputs();
                  setState(() {
                    //inputs = tempInputs;
                  });
                },
                child: const Text("Submit"),
              ),
              const Divider(height: 10),
              FutureBuilder(
                future: Future(() async {
                  setState(() async {
                    //inputs = await controller.getInputs() ??
                    List<String>.empty(growable: true);
                  });
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: ListView(
                        children: inputs?.isNotEmpty ?? false
                            ? inputs!.map<ListTile>((input) {
                                return ListTile(
                                  title: Text(input),
                                );
                              }).toList()
                            : [],
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
