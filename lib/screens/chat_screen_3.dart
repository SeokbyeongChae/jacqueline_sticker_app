import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Widget> _messages = []; // 메시지 및 스티커 리스트
  bool _showStickerPicker = false; // 스티커 키보드 표시 여부

  // 스티커 이미지 리스트
  final List<String> stickers = [
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
    'images/stickers/sticker1.jpg',
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _controller.text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      });
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _sendSticker(String stickerPath) {
    setState(() {
      _messages.add(
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              stickerPath,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );
      _showStickerPicker = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _messages[index],
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    setState(() {
                      _showStickerPicker = !_showStickerPicker;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      if (_showStickerPicker) {
                        setState(() {
                          _showStickerPicker = false;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          // 스티커 키보드 표시
          if (_showStickerPicker)
            Container(
              height: 250,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                ),
                itemCount: stickers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _sendSticker(stickers[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(stickers[index]),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
