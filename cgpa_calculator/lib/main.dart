import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'theme.dart';
import 'widgets/course_form.dart';
import 'widgets/course_list.dart';

void main() {
  runApp(const CgpaApp());
}

class CgpaApp extends StatefulWidget {
  const CgpaApp({Key? key}) : super(key: key);

  @override
  State<CgpaApp> createState() => _CgpaAppState();
}

class _CgpaAppState extends State<CgpaApp> {
  bool _useGreen = false;

  void _setGreen(bool v) => setState(() => _useGreen = v);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: MaterialApp(
        title: 'CGPA Calculator',
        debugShowCheckedModeBanner: false,
        theme: _useGreen ? AppTheme.greenTheme() : AppTheme.blueTheme(),
        home: HomePage(onThemeChanged: _setGreen, isGreen: _useGreen),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final void Function(bool) onThemeChanged;
  final bool isGreen;
  const HomePage({Key? key, required this.onThemeChanged, required this.isGreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CGPA Calculator'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (s) {
              if (s == 'blue') onThemeChanged(false);
              if (s == 'green') onThemeChanged(true);
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: 'blue',
                checked: !isGreen,
                child: Text('Blue Theme', style: TextStyle(color: Colors.blue.shade700)),
              ),
              CheckedPopupMenuItem(
                value: 'green',
                checked: isGreen,
                child: Text('Green Theme', style: TextStyle(color: Colors.green.shade700)),
              ),
            ],
            icon: const Icon(Icons.color_lens),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final horizontalPadding = isWide ? 24.0 : 12.0;

          // account for keyboard (viewInsets) and system safe area (viewPadding)
          final viewInsets = MediaQuery.of(context).viewInsets.bottom;
          final viewPadding = MediaQuery.of(context).viewPadding.bottom;
          final bottomPad = math.max(viewInsets, viewPadding);

          // limit form height on narrow screens to avoid forcing overflow
          final double formMaxHeight = isWide ? double.infinity : (constraints.maxHeight * 0.45).clamp(260.0, constraints.maxHeight);

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey<bool>(isWide), // Key to trigger the animation
              padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, bottomPad + 12),
              child: isWide
                  ? Row(
                      children: [
                        // left column: scrollable, constrained form
                        Flexible(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                              child: Column(
                                children: const [
                                  CourseForm(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        // right column: list (take more space)
                        Flexible(
                          flex: 6,
                          child: Card(
                            elevation: 4.0, // Increased elevation for better depth
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CourseList(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // Constrain and allow scrolling for the form so keyboard or small heights don't overflow
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: formMaxHeight),
                          child: const SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: CourseForm(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // course list fills remaining space
                        const Expanded(child: CourseList()),
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }
}
