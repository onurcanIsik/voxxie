import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxxie/colors/colors.dart';
import 'package:voxxie/core/bloc/settings/theme.bloc.dart';
import 'package:voxxie/core/extensions/context.extension.dart';
import 'package:voxxie/core/shared/shared_manager.dart';
import 'package:voxxie/core/util/enums/shared_keys.dart';
import 'package:voxxie/core/util/extension/string.extension.dart';
import 'package:voxxie/core/util/localization/locale_keys.g.dart';
import 'package:voxxie/pages/home/search/user_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  final String userName =
      SharedManager.getString(SharedKeys.userName).toString();

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
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
                ? FirebaseFirestore.instance
                    .collection('Users')
                    .where(
                      'userID',
                      isNotEqualTo: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('Users')
                    .where(
                      'userName',
                      isGreaterThanOrEqualTo: searchQuery,
                      isLessThan: '${searchQuery}z',
                      isNotEqualTo: userName,
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
                    String ownerID = document['userID'];

                    return Padding(
                      padding: context.paddingAllLow * 0.5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPageSearch(
                                userImage: userImage,
                                userName: username,
                                ownerID: ownerID,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: isDarkTheme ? lightBgColor : darkBgColor,
                          child: ListTile(
                            title: Text(
                              username,
                              style: GoogleFonts.fredoka(
                                color: isDarkTheme ? darkBgColor : lightBgColor,
                              ),
                            ),
                            trailing: userImage!.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(userImage),
                                  )
                                : const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      'assets/images/placeholder.jpg',
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
    final bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme!;
    return AppBar(
      elevation: 10,
      backgroundColor: isDarkTheme ? darkAppbarColorColor : lightAppbarColor,
      title: Text(
        LocaleKeys.user_serach_texts_appbar_text.locale,
      ),
    );
  }
}
