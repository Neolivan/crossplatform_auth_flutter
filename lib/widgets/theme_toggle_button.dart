import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/global_states/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool showText;
  final IconData? lightIcon;
  final IconData? darkIcon;
  final String? lightText;
  final String? darkText;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ThemeToggleButton({
    super.key,
    this.showText = false,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.lightText = 'Modo Claro',
    this.darkText = 'Modo Escuro',
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          onPressed: () => themeProvider.toggleTheme(),
          icon: Icon(
            themeProvider.isDarkMode ? lightIcon : darkIcon,
            color: foregroundColor ?? Theme.of(context).iconTheme.color,
          ),
          tooltip: showText
              ? (themeProvider.isDarkMode ? lightText : darkText)
              : null,
          padding: padding,
          style: backgroundColor != null
              ? IconButton.styleFrom(backgroundColor: backgroundColor)
              : null,
        );
      },
    );
  }
}
