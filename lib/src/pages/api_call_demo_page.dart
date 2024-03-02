

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final apiCallProvider = FutureProvider.family((ref, String name) async {
  if (name.isEmpty) {
    throw Exception("Empty input");
  }
  final response = await http.get(Uri.parse("https://api.genderize.io/?name=${name}"));
  final res = jsonDecode(response.body) as Map<String, dynamic>;
  if (!res.containsKey("gender")) {
    return Future.value(res["error"]);
  }
  return Future.value( res["gender"] );
});



class APICallDemoPage extends ConsumerStatefulWidget {
  const APICallDemoPage({super.key});

  @override
  ConsumerState<APICallDemoPage> createState() => _APICallDemoPageState();
}

class _APICallDemoPageState extends ConsumerState<APICallDemoPage> {

  TextEditingController _controller = TextEditingController(text: "");
  String name = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final apiResponse = ref.watch(apiCallProvider(_controller.text));

    return Scaffold(
      appBar: AppBar(
        title: Text("APICallDemoPage"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _controller),
          const SizedBox(height: 30,),

          ElevatedButton(onPressed: () {
            setState(() {
              name = _controller.text;
            });
          }, child: const Text('Submit')),

          apiResponse.when(
              data: (response) {
                return Text("${_controller.text} is probably ${response ?? ""}");
              },
              error: (e, ss) {
                return Text("Error: ${e} \n${ss.toString()}");
              },
              loading: () {
                return const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                );
              },
          )
        ],
      ),
    );
  }
}
