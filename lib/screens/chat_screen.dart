import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jacqueline_sticker_app/constants.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  bool _showEmojiPicker = false; // 이모티콘 키보드 표시 여부

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
      });
      _controller.clear();
      _scrollToBottom();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _messages[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(), // TextField 위에 Divider 추가
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.emoji_emotions),
                        onPressed: () {
                          setState(() {
                            _showEmojiPicker = !_showEmojiPicker;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            //Do something with the user input.
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      TextButton(
                        onPressed: _sendMessage,
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                  // child: TextField(
                  //   controller: _controller,
                  //   decoration: const InputDecoration(
                  //     hintText: 'Enter message',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.send),
                //   onPressed: _sendMessage,
                // ),
              ],
            ),
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _controller.text += emoji.emoji;
                },
                config: Config(
                  height: 256,
                  checkPlatformCompatibility: true,
                  viewOrderConfig: const ViewOrderConfig(),
                  emojiViewConfig: EmojiViewConfig(
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    emojiSizeMax: 28 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.2
                            : 1.0),
                  ),
                  skinToneConfig: const SkinToneConfig(),
                  categoryViewConfig: const CategoryViewConfig(),
                  bottomActionBarConfig: const BottomActionBarConfig(),
                  searchViewConfig: const SearchViewConfig(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
