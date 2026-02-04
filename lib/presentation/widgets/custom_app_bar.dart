import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      toolbarHeight: 55, // Taller app bar
      leadingWidth: 70, // More space for the icon
      leading: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3), // White border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 35, // 70px diameter
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage('assets/images/icon.png'),
            onBackgroundImageError: (_, __) {},
          ),
        ),
      ),
      // Explicitly remove actions to remove heart/sun icons
      actions: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Match toolbarHeight
}
