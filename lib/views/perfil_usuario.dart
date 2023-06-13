import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 8.0,
                    offset: Offset(4.0, 4.0),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 8.0,
                    offset: Offset(-4.0, -4.0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 64.0,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Software Developer',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileStat('Followers', '10K'),
                      _buildProfileStat('Following', '500'),
                      _buildProfileStat('Posts', '1.5K'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 8.0,
                    offset: Offset(4.0, 4.0),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 8.0,
                    offset: Offset(-4.0, -4.0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed cursus, augue et maximus semper, nibh nulla luctus ligula, in convallis neque erat a metus. Suspendisse id metus ac arcu feugiat interdum vitae ac enim.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
