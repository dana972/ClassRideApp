import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> slideTexts = [
    "Welcome to ClassRide!",
    "🎓 Are you a Student?\nFind a bus to take you to university.",
    "🧑‍✈️ Are you a Driver?\nFind a bus owner and get employed.",
    "🚌 Are you a Bus Owner?\nApply to manage your trips.",
  ];

  List<Map<String, String>> fakeUsers = [];
  Map<String, String>? currentUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedRole = 'Student';
  final List<String> roles = ['Student', 'Driver', 'Owner'];

  final Color darkBlue = const Color(0xFF121435);
  final Color lightBackground = const Color(0xFFFAF9F0);
  final Color beige = const Color(0xFFEDEBCA);
  final Color orange = const Color(0xFFFF5722);

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _loadData();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      int nextPage = _currentPage + 1;
      if (nextPage >= slideTexts.length) {
        nextPage = 0;
      }
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('fake_users');
    final userJson = prefs.getString('current_user');

    if (usersJson != null) {
      final List<dynamic> decoded = jsonDecode(usersJson);
      fakeUsers = decoded.map((u) => Map<String, String>.from(u)).toList();
    }

    if (userJson != null) {
      currentUser = Map<String, String>.from(jsonDecode(userJson));
    }

    setState(() {});
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(fakeUsers);
    await prefs.setString('fake_users', encoded);
  }

  Future<void> _saveCurrentUser(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();
    currentUser = user;
    await prefs.setString('current_user', jsonEncode(user));
    setState(() {});
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    setState(() {
      currentUser = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _showAuthDialog(BuildContext context) {
    bool isLogin = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: lightBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isLogin ? 'Login' : 'Sign Up',
                style: TextStyle(color: darkBlue),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    if (!isLogin)
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                      ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    if (!isLogin)
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: const InputDecoration(labelText: 'Select Role'),
                        items: roles
                            .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedRole = value;
                            });
                          }
                        },
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text;
                        final fullName = nameController.text.trim();

                        if (isLogin) {
                          final user = fakeUsers.firstWhere(
                                (u) => u['email'] == email && u['password'] == password,
                            orElse: () => {},
                          );
                          if (user.isNotEmpty) {
                            await _saveCurrentUser(user);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login successful!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid credentials')),
                            );
                          }
                        } else {
                          final exists = fakeUsers.any((u) => u['email'] == email);
                          if (exists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('User already exists!')),
                            );
                          } else {
                            final newUser = {
                              'name': fullName,
                              'email': email,
                              'password': password,
                              'role': selectedRole,
                            };
                            fakeUsers.add(newUser);
                            await _saveUsers();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sign Up successful! Please log in.')),
                            );
                          }
                        }

                        emailController.clear();
                        passwordController.clear();
                        nameController.clear();
                      },
                      child: Text(isLogin ? 'Login' : 'Sign Up'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Login",
                        style: TextStyle(color: darkBlue),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _goToDashboard() {
    if (currentUser != null) {
      final role = currentUser!['role'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to $role Dashboard...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Class',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'Ride',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: orange,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (currentUser != null)
            TextButton.icon(
              onPressed: _goToDashboard,
              icon: const Icon(Icons.dashboard, color: Colors.white),
              label: const Text('Dashboard', style: TextStyle(color: Colors.white)),
            ),
          TextButton.icon(
            onPressed: () {
              if (currentUser != null) {
                _logout();
              } else {
                _showAuthDialog(context);
              }
            },
            icon: Icon(
              currentUser == null ? Icons.login : Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              currentUser == null ? 'Sign Up / Login' : 'Logout',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: lightBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: darkBlue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.bus_alert, color: Colors.white, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome${currentUser != null ? ', ${currentUser!['name']}' : ''}!',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Home')),
            const ListTile(leading: Icon(Icons.info), title: Text('About')),
            const ListTile(leading: Icon(Icons.support), title: Text('Support')),
          ],
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (currentUser != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Welcome, ${currentUser!['name']}! You're logged in as a ${currentUser!['role']}.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: slideTexts.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Card(
                          elevation: 6,
                          color: beige,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                slideTexts[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        int prev = (_currentPage - 1 + slideTexts.length) % slideTexts.length;
                        _pageController.animateToPage(
                          prev,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        int next = (_currentPage + 1) % slideTexts.length;
                        _pageController.animateToPage(
                          next,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slideTexts.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? orange : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left text
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "ClassRide is a smart student bus management system that connects students, drivers, and bus owners in one platform. "
                              "Our goal is to make university transportation more organized, secure, and efficient for everyone involved.",
                          style: TextStyle(fontSize: 16, color: darkBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right image
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/1995/1995516.png",
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: beige,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: Text(
                  "© 2025 ClassRide. All rights reserved.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
