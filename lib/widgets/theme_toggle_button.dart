import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants/enums/labels_enum.dart';
import '../utils/global_states/theme_provider.dart';

/// Widget para alternar entre tema claro e escuro
class ThemeToggleButton extends StatelessWidget {
  /// Se deve exibir texto junto com o ícone
  final bool showText;

  /// Ícone para o modo claro
  final IconData? lightIcon;

  /// Ícone para o modo escuro
  final IconData? darkIcon;

  /// Texto para o modo claro
  final String? lightText;

  /// Texto para o modo escuro
  final String? darkText;

  /// Padding do botão
  final EdgeInsetsGeometry? padding;

  /// Cor de fundo do botão
  final Color? backgroundColor;

  /// Cor do ícone
  final Color? foregroundColor;

  const ThemeToggleButton({
    super.key,
    this.showText = false,
    this.lightIcon = Icons.light_mode,
    this.darkIcon = Icons.dark_mode,
    this.lightText = LabelsEnum.lightMode,
    this.darkText = LabelsEnum.darkMode,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          onPressed: themeProvider.isInitialized
              ? () => themeProvider.toggleTheme()
              : null,
          icon: themeProvider.isInitialized
              ? Icon(
                  themeProvider.isDarkMode ? lightIcon : darkIcon,
                  color: foregroundColor ?? Theme.of(context).iconTheme.color,
                )
              : SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor ?? Theme.of(context).iconTheme.color,
                  ),
                ),
          tooltip: themeProvider.isInitialized && showText
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
