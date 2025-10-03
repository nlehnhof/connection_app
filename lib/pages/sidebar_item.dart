import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget Function()? destinationBuilder;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.destinationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap ??
            () {
              if (destinationBuilder != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destinationBuilder!()),
                );
              }
            },
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 28),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
