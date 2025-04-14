import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  final Map<String, dynamic>? studentToOpen;
  ChatsPage({this.studentToOpen});

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<Map<String, dynamic>> conversations = [
    {
      'name': 'Fatima El-Sayed',
      'lastMessage': 'Sure, see you tomorrow!',
      'timestamp': '2:45 PM',
      'messages': [
        {'text': 'Hi Fatima!', 'fromMe': true},
        {'text': 'Hello! How are you?', 'fromMe': false},
        {'text': 'All good. Ready for tomorrow?', 'fromMe': true},
        {'text': 'Sure, see you tomorrow!', 'fromMe': false},
      ]
    },
    {
      'name': 'Ahmed Zaki',
      'lastMessage': 'Trip was great today.',
      'timestamp': '1:10 PM',
      'messages': [
        {'text': 'Hey Ahmed, how was the route?', 'fromMe': true},
        {'text': 'Trip was great today.', 'fromMe': false},
      ]
    },
    {
      'name': 'Youssef Kamal',
      'lastMessage': 'Can I change my schedule?',
      'timestamp': '11:30 AM',
      'messages': [
        {'text': 'Youssef, need any help?', 'fromMe': true},
        {'text': 'Can I change my schedule?', 'fromMe': false},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    // Automatically open the chat if studentToOpen is passed
    if (widget.studentToOpen != null) {
      Future.delayed(Duration.zero, () {
        _openChatModal(context, {
          'name': widget.studentToOpen!['name'],
          'messages': [
            {'text': 'Hello, any issues with your trip today?', 'fromMe': true},
          ],
        });
      });
    }
  }

  void _openChatModal(BuildContext context, Map<String, dynamic> convo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Chat with ${convo['name']}", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: convo['messages'].length,
                  itemBuilder: (context, index) {
                    final msg = convo['messages'][index];
                    return Align(
                      alignment: msg['fromMe'] ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: msg['fromMe'] ? Colors.teal.shade100 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(msg['text']),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Type a message...",
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: conversations.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final convo = conversations[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal,
            child: Text(convo['name']![0]),
          ),
          title: Text(convo['name']),
          subtitle: Text(convo['lastMessage']),
          trailing: Text(
            convo['timestamp'],
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () => _openChatModal(context, convo),
        );
      },
    );
  }
}
