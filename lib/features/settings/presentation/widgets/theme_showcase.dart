import 'package:flutter/material.dart';

/// Theme Showcase Widget
/// This widget demonstrates various themed components to preview a theme
class ThemeShowcase extends StatelessWidget {
  const ThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Typography', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Headline Large', style: textTheme.headlineLarge),
            Text('Headline Medium', style: textTheme.headlineMedium),
            Text('Headline Small', style: textTheme.headlineSmall),
            Text('Title Large', style: textTheme.titleLarge),
            Text('Title Medium', style: textTheme.titleMedium),
            Text('Title Small', style: textTheme.titleSmall),
            Text('Body Large', style: textTheme.bodyLarge),
            Text('Body Medium', style: textTheme.bodyMedium),
            Text('Body Small', style: textTheme.bodySmall),
            const SizedBox(height: 16),
            Text('Colors', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildColorPalette(context),
            // const SizedBox(height: 16),
            Text('Components', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildComponentsShowcase(context),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPalette(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildColorChip(context, 'Primary', colorScheme.primary),
        _buildColorChip(context, 'Secondary', colorScheme.secondary),
        _buildColorChip(context, 'Surface', colorScheme.surface),
        _buildColorChip(context, 'Background', colorScheme.surface),
        _buildColorChip(context, 'Error', colorScheme.error),
      ],
    );
  }

  Widget _buildColorChip(BuildContext context, String label, Color color) {
    final textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            Text(
              '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
              style: TextStyle(color: textColor, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentsShowcase(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buttons
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Text'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Input fields
        Text('Input Fields', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Text Field',
            hintText: 'Enter text',
            helperText: 'Helper text',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Password Field',
            hintText: 'Enter password',
            errorText: 'Error message',
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),

        // Selection controls
        Text('Selection Controls',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Checkbox(value: true, onChanged: (_) {}),
            Switch(value: true, onChanged: (_) {}),
            Radio(value: 1, groupValue: 1, onChanged: (_) {}),
          ],
        ),
      ],
    );
  }
}
