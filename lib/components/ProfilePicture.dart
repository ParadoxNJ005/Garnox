import 'package:flutter/material.dart';
import 'UserColor.dart';

class ProfilePicture extends StatefulWidget {
  final double radius;

  // New optional parameters for username, logo, and name
  final String? username;
  final String? logo;
  final String? name;

  const ProfilePicture({
    super.key,
    required this.radius,
    this.username,
    this.logo,
    this.name,
  });

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {

  @override
  Widget build(BuildContext context) {

    // Determine username, logo, and name to use in profile
    final username = widget.username;
    final logo = widget.logo;
    final name = widget.name;

    // Set a background color based on username (if available)
    final colors = [
      Colors.blue,
      Colors.blueAccent,
      Colors.lightBlue,
      Colors.lightBlueAccent,
      Colors.blue,
    ];
    final backgroundColor = username != null
        ? UserColorUtil.getUserColor(username, colors)
        : Colors.grey;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: widget.radius,
          backgroundImage: logo != null && logo.isNotEmpty ? NetworkImage(logo) : null,
          backgroundColor: logo == null || logo.isEmpty ? backgroundColor : null,
          child: (logo == null || logo.isEmpty) ? Center(
            child: Text(
              (name != null && name.isNotEmpty) ? name[0].toUpperCase() : 'N/A',
              style: TextStyle(
                fontSize: widget.radius - 30,
                color: Colors.white,
              ),
            ),
          ) : null,
        ),
      ],
    );
  }
}