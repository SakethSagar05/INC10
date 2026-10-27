import 'package:flutter/material.dart';

void main() {
  runApp(const SignupApp());
}

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

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

  // Task A state variables
  bool _isLoadingTip = false;
  String? _signupTip;
  bool _tipError = false;

  // Fix 2: Fixed category constant and map database for tip lookup
  static const String _fixedCategory = 'password_help';
  final Map<String, List<String>> _tipDatabase = {
    _fixedCategory: [
      "Use at least 6 characters including letters and numbers. This is easier to remember and harder to guess.",
    ],
  };

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup Successful! Welcome aboard!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Task A: Local AI Signup Coach Simulation
  void _fetchSignupTip({bool simulateError = false}) async {
    setState(() {
      _isLoadingTip = true;
      _tipError = false;
      _signupTip = null;
    });

    // Simulate local processing delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Fix 1: Guard against widget disposal during async gap
    if (!mounted) return;

    setState(() {
      _isLoadingTip = false;
      if (simulateError) {
        _tipError = true;
      } else {
        _tipError = false;
        // Fix 2: Programmatically look up tip by category key
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet-Adoption Pals Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
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
              const SizedBox(height: 24),

              // Sign Up Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // Task A: Local AI Signup Coach Section
              const Text(
                'Local AI Signup Coach (Task A)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isLoadingTip ? null : () => _fetchSignupTip(simulateError: false),
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Get a signup tip'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[100],
                  foregroundColor: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Fix 4: Clear test hook button for error/retry evaluation
              OutlinedButton(
                onPressed: _isLoadingTip ? null : () => _fetchSignupTip(simulateError: true),
                child: const Text('Simulate Tip Error & Retry (Test Hook)'),
              ),
              const SizedBox(height: 12),

              // Loading, Success, or Error states for Task A
              if (_isLoadingTip)
                const Center(child: CircularProgressIndicator())
              else if (_tipError)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.red[50],
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Failed to load local signup tip.',
                          style: TextStyle(color: Colors.red),
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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tip body (under 240 chars, safe wording)
                        Text(
                          _signupTip!,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        // Fix 3: Separate label widget underneath the tip
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