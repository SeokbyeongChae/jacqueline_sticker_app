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
    // Add other stickers here
  ];

  // 메시지 전송 함수
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _parseMessage(_controller.text),
            ),
          ),
        );
      });
      _controller.clear();
      _scrollToBottom();
    }
  }

  // 메시지에서 스티커 태그를 인식하고 텍스트와 스티커 이미지를 함께 표시하는 함수
  Widget _parseMessage(String text) {
    // 정규 표현식에 'banana'를 포함하여 나누기
    List<String> parts =
        text.split(RegExp(r'(?<=\[sticker\d+\])|(?=\[sticker\d+\])'));

    List<Widget> widgets = [];
    for (var part in parts) {
      if (part.startsWith('[sticker')) {
        // 텍스트가 스티커 태그일 경우
        final stickerIndex = int.parse(part.replaceAll(RegExp(r'\D'), ''));
        if (stickerIndex >= 0 && stickerIndex < stickers.length) {
          widgets.add(Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              stickers[stickerIndex],
              width: 50,
              height: 50,
            ),
          ));
        }
      } else {
        // 일반 텍스트
        widgets.add(Text(
          part,
          style: TextStyle(color: Colors.white),
        ));
      }
    }
    return Wrap(children: widgets);
  }

  // 스티커 추가하는 함수
  void _addStickerToMessage(int stickerIndex) {
    setState(() {
      // TextField에 스티커 태그 추가
      _controller.text += '[sticker$stickerIndex]';
      // _showStickerPicker = false;
    });
    _scrollToBottom();
  }

  // 스크롤을 하단으로 이동시키는 함수
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
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

  // 백키 눌렀을 때 스티커 키보드 닫는 함수
  Future<bool> _onWillPop() async {
    if (_showStickerPicker) {
      setState(() {
        _showStickerPicker = false;
      });
      return false; // 스티커 키보드를 닫고 뒤로 이동하지 않음
    }
    return true; // 스티커 키보드가 닫혀있으면 기본 뒤로가기 동작 수행
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('⚡Jacqueline\'s sticker app'),
          backgroundColor: Colors.lightBlueAccent,
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
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions),
                    onPressed: () {
                      setState(() {
                        _showStickerPicker = !_showStickerPicker;
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter message',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        setState(() {
                          _showStickerPicker =
                              true; // TextField 활성화 시 스티커 키보드 표시
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: stickers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _addStickerToMessage(index);
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
      ),
    );
  }
}
