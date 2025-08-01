import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color.fromARGB(137, 66, 66, 66)
        : Colors.grey.shade100;
    final textColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600;

    return GestureDetector(
      onTap: () {
        // Navigate to search screen when search bar is tapped
        context.push('/search');
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Search your needed',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade700 : Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.tune,
                color: textColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
