import 'package:flutter/material.dart';
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RuleBookScreen extends StatefulWidget {
  const RuleBookScreen({Key? key}) : super(key: key);

  @override
  State<RuleBookScreen> createState() => _RuleBookScreenState();
}

class _RuleBookScreenState extends State<RuleBookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool isLoading = false;
  List<String> rules = [];

  void performSearch(String value) {
    setState(() {
      searchQuery = value.trim();
    });
  }

  void fetchRuleBook(String placeName) async {
    setState(() {
      isLoading = true;
    });

    final apiUrl = 'https://tokma.onrender.com/api/tourist/rule';
    final response =
        await http.post(Uri.parse(apiUrl), body: {'name': placeName});

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success']) {
        setState(() {
          rules = List<String>.from(jsonResponse['name']);
          print("Response: $jsonResponse['name']");
        });
      } else {
        setState(() {
          rules = [];
        });
      }
    } else {
      setState(() {
        rules = [];
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
    mq = MediaQuery.of(context).size;
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
          : rules.isEmpty
              ? Center(child: Text('No rules found for "$searchQuery"'))
              : ListView.builder(
                  itemCount: rules.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          searchQuery,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Text('${index}. ${rules[index - 1]}'),
                      );
                    }
                  },
                ),
    );
  }
}
