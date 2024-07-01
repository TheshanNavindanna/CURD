import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Flutter CRUD App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UserListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return ListView.builder(
            itemCount: userProvider.users.length,
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserFormScreen(index: index),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    userProvider.deleteUser(index);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserFormScreen extends StatefulWidget {
  final int? index;

  UserFormScreen({this.index});

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      final user = Provider.of<UserProvider>(context, listen: false).users[widget.index!];
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(widget.index == null ? 'Add User' : 'Update User'),
              onPressed: () {
                final firstName = _firstNameController.text;
                final lastName = _lastNameController.text;
                final email = _emailController.text;

                final user = User(
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                );

                if (widget.index == null) {
                  Provider.of<UserProvider>(context, listen: false).addUser(user);
                } else {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateUser(widget.index!, user);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
