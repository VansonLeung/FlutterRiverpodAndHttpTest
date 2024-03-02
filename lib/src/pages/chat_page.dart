import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_websocket_chat/src/providers/websocket_providers.dart';


class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channel = ref.watch(webSocketProvider);
    // final histories = ref.watch()

    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text('Waiting for data...');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter message',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Send Message'),
              onPressed: () {
                final message = _textEditingController.text;
                if (message.isNotEmpty) {
                  channel.sink.add(message);
                  _textEditingController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
