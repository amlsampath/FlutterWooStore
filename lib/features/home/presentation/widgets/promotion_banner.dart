import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class PromotionBanner extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;

  const PromotionBanner({super.key})
      : imagePath = null,
        onTap = null;

  const PromotionBanner.image({required this.imagePath, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      );
    }
    // TODO: Replace with actual promotion data from API
    final endTime = DateTime.now().millisecondsSinceEpoch +
        1000 * 60 * 60 * 24; // 24 hours from now

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flash Sale!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Up to 50% off on selected items',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 16),
                CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      return const Text(
                        'Sale Ended',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return Row(
                      children: [
                        _buildTimeBox(time.hours ?? 0, 'H'),
                        const SizedBox(width: 8),
                        _buildTimeBox(time.min ?? 0, 'M'),
                        const SizedBox(width: 8),
                        _buildTimeBox(time.sec ?? 0, 'S'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to flash sale products
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(int value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${value.toString().padLeft(2, '0')}$label',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
