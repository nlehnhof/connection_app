import 'package:flutter/material.dart';
import 'package:riddles/pages/home_page.dart';
import 'package:riddles/pages/riddles_page.dart';
import 'package:riddles/pages/sidebar_item.dart';
import 'package:riddles/pages/jokes_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.red,
      child: SafeArea(
        child: Column(
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 35),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            const SizedBox(height: 55),

            // Top section items
            ...[
              SidebarItem(
                  destinationBuilder: () => HomePage(),
                  title: "Home Page",
                  icon: Icons.home,
              ),
              SidebarItem(
                  destinationBuilder: () => JokePage(),
                  title: "Jokes",
                  icon: Icons.emoji_emotions,
               ),
              SidebarItem(
                  destinationBuilder: () => RiddlePage(),
                  title: "Riddles",
                  icon: Icons.extension,
               ),
            ].expand((item) => [
                  item,
                  const SizedBox(height: 10),
                ]).toList()
              ..removeLast(),

            const Spacer(),

            // Bottom section
            // SidebarItem(
            //     destinationBuilder: () => ProfilePage(),
            // const SizedBox(height: 10),

            // Settings / Logout
          ],
        ),
      ),
    );
  }
}
