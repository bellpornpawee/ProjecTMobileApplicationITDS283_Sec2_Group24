import 'package:flutter/material.dart';
import 'database_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  // ฟังก์ชันค้นหาสินค้าจากฐานข้อมูล
  void _searchItems() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final results = await DatabaseHelper.instance.searchItems(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // TextField สำหรับกรอกคำค้นหา
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for items',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchItems(); // เมื่อกรอกคำค้นหาจะค้นหาอัตโนมัติ
              },
            ),
            const SizedBox(height: 16),
            // แสดงผลลัพธ์การค้นหา
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(item['name'] ?? 'No Name'),
                            subtitle: Text(item['subtitle'] ?? 'No Subtitle'),
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
