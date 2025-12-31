import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CVHomePage(),
    );
  }
}

class CVHomePage extends StatefulWidget {
  const CVHomePage({super.key});

  @override
  _CVHomePageState createState() => _CVHomePageState();
}

class _CVHomePageState extends State<CVHomePage> {
  String _selectedTheme = 'Modern'; // Default theme

  final ScrollController _scrollController = ScrollController();

  // Background colors based on theme
  Color getBackgroundColor() {
    switch (_selectedTheme) {
      case 'Classic':
        return Colors.grey[200]!; // Light Classic
      case 'Modern':
        return const Color(0xFF0D1B2A); // Dark Navy Professional
      case 'Creative':
        return Colors.grey[400]!; // Silver Background
      default:
        return const Color(0xFF0D1B2A);
    }
  }

  // Card builder with animation
  Widget buildAnimatedCard({required Widget child}) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.95, end: 1),
      curve: Curves.easeInOut,
      builder: (context, double scale, _) {
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: 200, // Fixed uniform height
              width: double.infinity,
              decoration: BoxDecoration(
                color: _selectedTheme == "Classic"
                    ? Colors.white // Light cards for Classic
                    : Colors.blueGrey[900], // Dark cards for Modern/Creative
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Color getTextColor() {
    return _selectedTheme == "Classic" ? Colors.black87 : Colors.white;
  }

  Color getSubTextColor() {
    return _selectedTheme == "Classic" ? Colors.black54 : Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              getBackgroundColor(),
              getBackgroundColor().withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true, // scrollbar hamesha dikhay ga
          thickness: 8, // scrollbar ki motai
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Theme Selection Buttons
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _selectedTheme = 'Classic'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white),
                        child: const Text("Classic"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _selectedTheme = 'Modern'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white),
                        child: const Text("Modern"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => _selectedTheme = 'Creative'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white),
                        child: const Text("Creative"),
                      ),
                    ],
                  ),
                ),

                // Profile Card
                buildAnimatedCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/images/rayan.jpg"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Rayan Shahbaz",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: getTextColor()),
                      ),
                      Text(
                        "Full-Stack Developer & AI Enthusiast",
                        style:
                        TextStyle(fontSize: 14, color: getSubTextColor()),
                      ),
                    ],
                  ),
                ),

                // About Me Card
                buildAnimatedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Me",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getTextColor()),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "I’m Rayan Shahbaz, a passionate developer with strong interest in AI, Flutter apps, and software development. "
                            "I enjoy building innovative solutions and working on projects that make an impact.",
                        style:
                        TextStyle(color: getSubTextColor(), fontSize: 14),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Skills Card
                buildAnimatedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Core Skills",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getTextColor()),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Chip(
                              label: const Text("AI Development"),
                              backgroundColor: _selectedTheme == "Classic"
                                  ? Colors.blueGrey
                                  : Colors.white24,
                              labelStyle:
                              const TextStyle(color: Colors.white)),
                          Chip(
                              label: const Text("Flutter App Development"),
                              backgroundColor: _selectedTheme == "Classic"
                                  ? Colors.blueGrey
                                  : Colors.white24,
                              labelStyle:
                              const TextStyle(color: Colors.white)),
                          Chip(
                              label: const Text("WordPress"),
                              backgroundColor: _selectedTheme == "Classic"
                                  ? Colors.blueGrey
                                  : Colors.white24,
                              labelStyle:
                              const TextStyle(color: Colors.white)),
                          Chip(
                              label: const Text("Python Development"),
                              backgroundColor: _selectedTheme == "Classic"
                                  ? Colors.blueGrey
                                  : Colors.white24,
                              labelStyle:
                              const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Experience Card
                buildAnimatedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Experience",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getTextColor()),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "⚡ Worked on AI-powered solutions and automation tools.\n"
                            "⚡ Built Flutter apps with clean UI/UX.\n"
                            "⚡ Experience in database integration and full-stack projects.\n"
                            "⚡ Active in learning and teaching modern tech.",
                        style:
                        TextStyle(color: getSubTextColor(), fontSize: 14),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Contact Card
                buildAnimatedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getTextColor()),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email, color: getSubTextColor()),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "rayanshahbaz573@gmail.com",
                              style: TextStyle(color: getSubTextColor()),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, color: getSubTextColor()),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "+923270671697",
                              style: TextStyle(color: getSubTextColor()),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
