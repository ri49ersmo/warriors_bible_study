import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import 'bible_chapters_page.dart';

class BibleBooksPage extends StatefulWidget {
  @override
  _BibleBooksPageState createState() => _BibleBooksPageState();
}

class _BibleBooksPageState extends State<BibleBooksPage> {
  late Future<List<String>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = BibleService.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bible Books")),
      body: FutureBuilder<List<String>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading books"));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BibleChaptersPage(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
