import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class VerseService {
  final String apiKey = "5cb7a6e9922bf5454780d99b13e538ec42171fff";

  final List<String> books = [
    "Genesis",
    "Exodus",
    "Psalms",
    "Proverbs",
    "Isaiah",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "Revelation",
  ];

  Future<String> getVerseOfTheDay() async {
    try {
      final random = Random();
      final book = books[random.nextInt(books.length)];
      final chapter = random.nextInt(10) + 1;
      final verse = random.nextInt(20) + 1;

      final query = "$book $chapter:$verse";

      final url = Uri.parse(
        "https://api.esv.org/v3/passage/text/?q=$query"
        "&include-passage-references=true"
        "&include-verse-numbers=false"
        "&include-headings=false"
        "&include-footnotes=false",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Token $apiKey",
        },
      );

      print("API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["passages"] != null &&
            data["passages"] is List &&
            data["passages"].isNotEmpty) {
          return data["passages"][0].trim();
        } else {
          return "No verse returned for $query.";
        }
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
