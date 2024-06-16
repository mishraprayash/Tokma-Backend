import 'package:flutter/material.dart';
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yatri/database/db_handler.dart';

class RuleBookScreen extends StatefulWidget {
  const RuleBookScreen({Key? key}) : super(key: key);

  @override
  State<RuleBookScreen> createState() => _RuleBookScreenState();
}

class _RuleBookScreenState extends State<RuleBookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool isLoading = false;
  List<Map<String, dynamic>> ruleBookList = [];

  void performSearch(String value) {
    setState(() {
      searchQuery = value.trim();
    });
  }

  Future<void> fetchRuleBook(String placeName) async {
    setState(() {
      isLoading = true;
    });
    placeName = placeName.trim();

    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      if (token != null) {
        final apiUrl = 'https://tokma.onrender.com/api/tourist/rule';
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: json.encode({'name': placeName}),
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);

          if (jsonResponse.containsKey('data') &&
              jsonResponse['data'].isNotEmpty) {
            setState(() {
              ruleBookList =
                  List<Map<String, dynamic>>.from(jsonResponse['data']);
            });
          } else {
            setState(() {
              ruleBookList = [];
            });
          }
        } else {
          print('Failed to load rules: ${response.body}');
          setState(() {
            ruleBookList = [];
          });
        }
      } else {
        print('No session found');
        setState(() {
          ruleBookList = [];
        });
      }
    } catch (e) {
      print('Error fetching rule book: $e');
      setState(() {
        ruleBookList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: mq.width * .02,
          ),
          SizedBox(
            width: mq.width * 0.86,
            height: mq.height * 0.05,
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                performSearch(value);
                fetchRuleBook(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Rule Book...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            width: mq.width * .02,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide.none),
        child: SideMenuList(),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ruleBookList.isEmpty
              ? Center(
                  child: Text(
                    searchQuery.isEmpty
                        ? 'For Rule Book, search the place in the search bar above.'
                        : 'No rules found for "$searchQuery"',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: ruleBookList.length,
                  itemBuilder: (context, index) {
                    final ruleBookDetails = ruleBookList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (ruleBookDetails.containsKey('profile') &&
                                ruleBookDetails['profile'] != null)
                              // Use FadeInImage with a placeholder
                              FadeInImage(
                                placeholder: AssetImage('assets/loading.png'),
                                image: ruleBookDetails['profile'].isEmpty
                                    ? AssetImage('assets/default.png')
                                        as ImageProvider
                                    : NetworkImage(ruleBookDetails['profile']),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200, // Adjust height as needed
                              ),
                            if (ruleBookDetails.containsKey('name'))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Text(
                                        ruleBookDetails['name'],
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Rule Book',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            if (ruleBookDetails.containsKey('rules') &&
                                ruleBookDetails['rules'] != null &&
                                ruleBookDetails['rules'].isNotEmpty)
                              ...List.generate(
                                ruleBookDetails['rules'].length,
                                (ruleIndex) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          ruleBookDetails['rules'][ruleIndex],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
