import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webSocketProvider = Provider<WebSocketChannel>((ref) {
  return IOWebSocketChannel.connect('wss://flutter-tom-ws.www.vanportdev.com:8766');
});



