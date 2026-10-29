import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

// The Ballroom: a one-way finish screen. The name arrives by constructor.
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, required this.userName});

  final String userName;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _confetti.play(); // fire the cannon once, on arrival
  }

  @override
  void dispose() {
    _confetti.dispose(); // every controller gets a proper burial
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('\u{1F383}', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome, ${widget.userName}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Your haunted guest pass is confirmed.'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    // Escort the guest home to the first route (the Foyer).
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text('Back to the Foyer'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 25,
              gravity: 0.2,
              colors: const [
                Color(0xFFFB923C), // jack-o'-lantern orange
                Color(0xFFA78BFA), // ghost violet
                Color(0xFF4ADE80), // crypt green
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
