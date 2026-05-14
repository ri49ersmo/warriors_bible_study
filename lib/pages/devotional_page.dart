import 'package:flutter/material.dart';
import '../services/devotional_service.dart';
import '../devotional.dart';

class DevotionalPage extends StatefulWidget {
  @override
  _DevotionalPageState createState() => _DevotionalPageState();
}

class _DevotionalPageState extends State<DevotionalPage> {
  Devotional? devo;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDevo();
  }

  Future<void> loadDevo() async {
    final todayDevo = await getTodayDevotional();
    setState(() {
      devo = todayDevo;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text("Devotional of the Day"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              children: [
                // ⭐ FULL-SCREEN BACKGROUND WALLPAPER
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/numbers_stamp.png"),
                          fit: BoxFit.cover,       // fills entire viewport
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),

                // ⭐ DARK OVERLAY FOR READABILITY
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),

                // ⭐ CONTENT LAYER
                loading
                    ? Center(child: CircularProgressIndicator())
                    : devo == null
                        ? Center(
                            child: Text(
                              "No devotional available.",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          )
                        : SafeArea(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    devo!.title,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 12),

                                  Text(
                                    devo!.verse,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  Text(
                                    devo!.text,
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
