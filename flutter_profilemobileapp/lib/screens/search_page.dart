//dart-flutter libraries
import 'package:flutter/material.dart';
import 'dart:async';

//main file
import '../main.dart';

//local files
import '../functions/functions.dart';
import 'profile_page.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //variables
  bool isLoading = true;

  Map<String, List<dynamic>>? searchResults;

  final _searchController = TextEditingController();
  final _uidController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await Future.delayed(Duration(milliseconds: 500));
    final data = await searchProfiles();
    if (mounted) {
      setState((){
        searchResults = data;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
      _debounce?.cancel();
      _searchController.dispose();
      _uidController.dispose();
      super.dispose();
  }

  void _runSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      String userIdInput = _uidController.text.trim();
      String searchTermInput = _searchController.text.trim();

      final String? finalUserId = userIdInput.isEmpty ? null : userIdInput;
      final String? finalSearchTerm = searchTermInput.isEmpty ? null : searchTermInput;

      final results = await searchProfiles(
        user_id: finalUserId,
        term: finalSearchTerm,
      );

      if (mounted) {
        setState(() {
          searchResults = results;
        });
      }
    });
  }

  List<Widget> _queryResults () {
    Map<String, List<dynamic>> data = searchResults!;

    List<dynamic> profiles = data['profiles'] ?? [];

    List<Widget> resultWidgets = [];

    for (List<dynamic> profile in profiles) {
      if (profile[0] != supabase.auth.currentSession?.user.id) {
        resultWidgets.add(
          InkWell(
            child: Container(
              height: 55,
              width: double.infinity,

              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF6D6D6D),
                    width: 0.25,
                  ) 
                )
              ),

              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFFFFF),
                      image: DecorationImage(
                        image:
                            !profile[5].toString().startsWith("DEFAULT_PROFILE_")
                            ? NetworkImage(profile[5].toString())
                            : AssetImage(
                                'assets/images/defaults/${profile[5].toString()}.png',
                              ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),

                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile[2].toString().replaceAll('|', '').isEmpty
                                ? profile[1].toString()
                                : profile[2].toString().replaceAll('|', ' '),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            "@${profile[1].toString()}",
                            style: TextStyle(
                              color: Color(0xFFC9C9C9),
                              fontWeight: FontWeight.w300,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),

            onTap: () {
              if(context.mounted){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(userId: profile[0]))
                );
              }
            }
          )
        );
      }
    }

    return resultWidgets;
  }

  Widget _SearchhArea() {
    return Container(
      margin: EdgeInsets.all(10),

      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User ID",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                TextFormField(
                  controller: _uidController,
                  onChanged: (value) {
                    _runSearch();
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter user ID...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 2),
                    filled: true,
                    fillColor: const Color(0xFFEEEEEE),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF8D8D8D)),
                      borderRadius: BorderRadius.zero,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF2D27D7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  style: TextStyle(fontSize: 15),

                  validator: (value) {
                    return null;
                  },
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Name",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    _runSearch();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 2),
                    filled: true,
                    fillColor: const Color(0xFFEEEEEE),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF8D8D8D)),
                      borderRadius: BorderRadius.zero,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF2D27D7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  style: TextStyle(fontSize: 15),

                  validator: (value) {
                    return null;
                  },
                ),
              ],
            ),
          ),

          Divider(
            color: const Color(0xFF6D6D6D), 
            thickness: 0.25, 
            height: 11
          ),

          Container(
            child: Column(
              children: [
                ..._queryResults(),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      )
    );
  }



  //actual build area
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),

        iconTheme: IconThemeData(color: Color(0xFFFFFFFF), size: 30),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [Color(0xFF2D27D7), Color(0xFF191755)],
            ),
          ),
        ),
      ),

      drawer: standardDrawer(context),

      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: searchResults == null
              ? Center(key: UniqueKey(), child: CircularProgressIndicator())
              : _SearchhArea()
          ),
        ),
      ),

    );
  }
}