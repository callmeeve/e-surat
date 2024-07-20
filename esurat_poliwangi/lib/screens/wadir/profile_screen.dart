import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esurat_poliwangi/services/auth_service.dart';

class WadirProfileScreen extends StatefulWidget {
  const WadirProfileScreen({super.key});

  @override
  State<WadirProfileScreen> createState() => _WadirProfileScreenState();
}

class _WadirProfileScreenState extends State<WadirProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.logout();
            },
            icon: const Icon(
              Icons.logout,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: FutureBuilder(
          future: authService.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading data: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                  ),
                ),
              );
            } else {
              final userData = snapshot.data as Map<String, dynamic>;
              return Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 100.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage(
                            'assets/images/user.png',
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Hello,",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                userData['username'] ?? 'No Username',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        InkWell(
                          onTap: () {},
                          child: const CircleAvatar(
                            radius: 16.0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 18.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListTile(
                    title: const Text("Nama"),
                    subtitle: Text(
                      userData['name'] ?? 'No Name',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text("Email"),
                    subtitle: Text(
                      userData['email'] ?? 'No Email',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
