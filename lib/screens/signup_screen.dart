import 'package:flutter/material.dart';

import 'success_screen.dart';

// The Laboratory: the Activity 10 form plus three upgrades
// (password toggle, birth-date picker, loading state).
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  // Potion A: true = dots, false = letters
  bool _obscurePassword = true;

  // Potion B: the chosen birth date (mirrored into _dateController)
  DateTime? _birthDate;

  // Potion C: true while the "potion is brewing"
  bool _submitting = false;

  // Activity 10 Task A state variables (carried over)
  bool _isLoadingTip = false;
  String? _signupTip;
  bool _tipError = false;

  static const String _fixedCategory = 'password_help';
  final Map<String, List<String>> _tipDatabase = {
    _fixedCategory: [
      "Use at least 6 characters including letters and numbers. This is easier to remember and harder to guess.",
    ],
  };

  // Potion C: validate, show a spinner, then swap the Lab for the Ballroom.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return; // the user may have left during the wait
    // pushReplacement(): the Lab is gone, so Back cannot resubmit the form.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  // Potion B: open the picker; no future birthdays allowed.
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  // Activity 10 Task A: local signup coach simulation (carried over)
  void _fetchSignupTip({bool simulateError = false}) async {
    setState(() {
      _isLoadingTip = true;
      _tipError = false;
      _signupTip = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Guard against widget disposal during the async gap
    if (!mounted) return;

    setState(() {
      _isLoadingTip = false;
      if (simulateError) {
        _tipError = true;
      } else {
        _tipError = false;
        final tips = _tipDatabase[_fixedCategory] ?? ["No tips available."];
        _signupTip = tips.first;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Signup Laboratory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Sign the Guest Book',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email containing "@"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field with Potion A (visibility toggle)
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Potion B (birth-date picker)
              TextFormField(
                controller: _dateController,
                readOnly: true, // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) =>
                    _birthDate == null ? 'Pick your birth date' : null,
                onTap: _pickBirthDate,
              ),
              const SizedBox(height: 24),

              // Sign Up Button with Potion C (loading state)
              ElevatedButton(
                onPressed: _submitting ? null : _submit, // null = disabled
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Join the Mansion',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // Activity 10 Task A: Local Signup Coach (carried over)
              const Text(
                'Local Signup Coach',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isLoadingTip
                    ? null
                    : () => _fetchSignupTip(simulateError: false),
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Get a signup tip'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _isLoadingTip
                    ? null
                    : () => _fetchSignupTip(simulateError: true),
                child: const Text('Simulate Tip Error & Retry (Test Hook)'),
              ),
              const SizedBox(height: 12),

              if (_isLoadingTip)
                const Center(child: CircularProgressIndicator())
              else if (_tipError)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Failed to load local signup tip.',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _fetchSignupTip(simulateError: false),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (_signupTip != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _signupTip!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Preset demo content — guidance only, not a security guarantee or AI output (Category: password_help)',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
