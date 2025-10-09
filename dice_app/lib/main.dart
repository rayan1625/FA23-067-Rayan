// main.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const LudoDiceApp());
}

class LudoDiceApp extends StatelessWidget {
  const LudoDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Fun',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomePage(),
    );
  }
}

class Player {
  String name;
  int score;
  Player({required this.name, this.score = 0});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<Player> players = [
    Player(name: 'Player 1', score: 0),
    Player(name: 'Player 2', score: 0),
  ];

  int currentTurn = 0;
  int diceValue = 1;
  bool isRolling = false;
  final Random _rand = Random();
  final TextEditingController _nameController = TextEditingController();

  late AnimationController _rotateController;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _rotationAnim = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void addPlayer() {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      players.add(Player(name: name, score: 0));
      _nameController.clear();
    });
  }

  void rollDice() {
    if (players.isEmpty) return;
    if (isRolling) return;

    setState(() => isRolling = true);
    _rotateController.reset();
    _rotateController.forward();

    const animDuration = Duration(milliseconds: 700);
    final timerInterval = 60;
    int elapsed = 0;
    Timer.periodic(Duration(milliseconds: timerInterval), (t) {
      elapsed += timerInterval;
      setState(() {
        diceValue = _rand.nextInt(6) + 1;
      });
      if (elapsed >= animDuration.inMilliseconds) {
        t.cancel();
        final finalValue = _rand.nextInt(6) + 1;
        setState(() {
          diceValue = finalValue;
          players[currentTurn].score += finalValue;

          // ✅ Check Winner
          if (players[currentTurn].score >= 50) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('🎉 Winner!'),
                content: Text('${players[currentTurn].name} has won the game with ${players[currentTurn].score} points!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            );
          } else {
            currentTurn = (currentTurn + 1) % players.length;
          }

          isRolling = false;
        });
      }
    });
  }

  void resetGame() {
    setState(() {
      for (var p in players) {
        p.score = 0;
      }
      currentTurn = 0;
      diceValue = 1;
    });
  }

  final List<Color> barColors = [
    const Color(0xFFE96060),
    const Color(0xFF668AFF),
    const Color(0xFF3BB273),
    const Color(0xFFFFC145),
  ];

  Widget buildAddPlayerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Player Name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter player name",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: addPlayer,
              icon: const Icon(Icons.add, size: 22),
              label: const Text('Add Player', style: TextStyle(fontSize: 17)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDiceArea(double width) {
    return Column(
      children: [
        Text(
          "It's ${players.isNotEmpty ? players[currentTurn].name : 'Player'}'s Turn!",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _rotationAnim,
              builder: (context, child) {
                return Transform.rotate(
                  angle: isRolling ? _rotationAnim.value : 0,
                  child: child,
                );
              },
              child: Container(
                width: width * 0.45, // ✅ smaller dice
                height: width * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900,
                      Colors.grey.shade800,
                      Colors.grey.shade700
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: DiceFace(value: diceValue),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: width * 0.7,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: isRolling || players.isEmpty ? null : rollDice,
            icon: const Icon(Icons.casino_outlined, size: 22),
            label: const Text('Roll Dice', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              elevation: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildScoreboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Scoreboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: players.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = players[index];
              final bg = barColors[index % barColors.length];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        p.score.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: Center(
        child: Text(
          '🎲 Ludo Fun!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0093E9),
              Color(0xFF80D0C7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTopBar(),
                  buildAddPlayerCard(),
                  buildDiceArea(size.width),
                  const SizedBox(height: 20),
                  buildScoreboard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiceFace extends StatelessWidget {
  final int value;
  const DiceFace({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFff6b6b), Color(0xFFffd166)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: Colors.black38,
                offset: Offset(0, 4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
