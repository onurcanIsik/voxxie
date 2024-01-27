import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/core/components/chats/chats_bubble.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';

class ConverstationPage extends StatefulWidget {
  final String userName;
  final String? userID;
  final String? conversationID;
  const ConverstationPage({
    super.key,
    required this.userName,
    this.userID,
    this.conversationID,
  });

  @override
  State<ConverstationPage> createState() => _ConverstationPageState();
}

class _ConverstationPageState extends State<ConverstationPage> {
  final messageController = TextEditingController();
  final List messageList = [];
  final formKey = GlobalKey<FormState>();
  CollectionReference? ref;

  @override
  void initState() {
    // todo: implement initState
    ref = FirebaseFirestore.instance
        .collection('chats/${widget.conversationID}/messages');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ref!.orderBy('timestamp').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Bir hata oluştu: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Veriler yükleniyor...');
                  }

                  final documents = snapshot.data?.docs;

                  if (documents != null && documents.isNotEmpty) {
                    return ListView(
                      children: documents.map((doc) {
                        final date = doc['timestamp'];
                        DateTime dateTime = date.toDate();
                        String formattedHour = DateFormat.Hm().format(dateTime);
                        return ListTile(
                          title: Align(
                            alignment: widget.userID == doc['senderID']
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ChatsBubbleWidget(
                              dateTime: formattedHour,
                              txt: doc['message'],
                              bottomRight: widget.userID == doc['senderID']
                                  ? const Radius.circular(0)
                                  : const Radius.circular(20),
                              bottomLeft: widget.userID != doc['senderID']
                                  ? const Radius.circular(0)
                                  : const Radius.circular(20),
                              topLeft: widget.userID == doc['senderID']
                                  ? const Radius.circular(20)
                                  : const Radius.circular(20),
                              topRight: widget.userID == doc['senderID']
                                  ? const Radius.circular(20)
                                  : const Radius.circular(0),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return SizedBox(
                    height: context.dynamicHeight(0.3),
                    width: context.dynamicWidth(0.3),
                    child: Image.asset('assets/images/emptyPage.png'),
                  );
                },
              ),
            ),
            _txtFormWidget(),
          ],
        ),
      ),
    );
  }

  Padding _txtFormWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        right: 20,
        left: 20,
        bottom: 50,
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return LocaleKeys.handle_texts_cannot_blank_text.locale;
          }
          return null;
        },
        controller: messageController,
        style: GoogleFonts.fredoka(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await ref!.add({
                  'senderID': widget.userID,
                  'message': messageController.text,
                  'timestamp': DateTime.now(),
                });
                messageController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.green,
      title: Text(widget.userName),
    );
  }
}
