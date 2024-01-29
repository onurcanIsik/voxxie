import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Padding(
            padding: context.paddingAllLow * 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: LocaleKeys.user_serach_texts_text_field_texts.locale,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          StreamBuilder(
            stream: (_searchController.text.isEmpty)
                ? FirebaseFirestore.instance.collection('Users').snapshots()
                : FirebaseFirestore.instance
                    .collection('Users')
                    .where(
                      'userName',
                      isGreaterThanOrEqualTo: searchQuery,
                      isLessThan: '${searchQuery}z',
                    )
                    .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((document) {
                    String username = document['userName'];
                    String? userImage = document['userImage'];

                    return Padding(
                      padding: context.paddingAllLow * 0.5,
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: ListTile(
                            title: Text(username),
                            trailing: userImage != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(userImage),
                                  )
                                : const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      'assets/placeholder.jpg',
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: btnColor,
      title: Text(
        LocaleKeys.user_serach_texts_appbar_text.locale,
      ),
    );
  }
}
