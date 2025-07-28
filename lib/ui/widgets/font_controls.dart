import 'package:celebrare_assignment/constants/font_family_list.dart';
import 'package:celebrare_assignment/cubit/canvas_cubit.dart';
import 'package:celebrare_assignment/cubit/canvas_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FontControls extends StatelessWidget {
  const FontControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFontSizeControls(context),
            const SizedBox(width: 25),
            _buildFontStyleControls(context),
            const SizedBox(width: 25),
            _buildFontFamilyControls(context),
            const SizedBox(width: 25),
            _buildColorControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildColorControls(BuildContext context) {
    // Re-introducing the original hardcoded colors
    final colors = [
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: BlocBuilder<CanvasCubit, CanvasState>(
            builder: (context, state) {
              final selectedIndex = state.textItems.length - 1;
              final selectedColor = selectedIndex >= 0
                  ? state.textItems[selectedIndex].color
                  : Colors.black;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...colors.map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        if (selectedIndex >= 0) {
                          context
                              .read<CanvasCubit>()
                              .changeTextColor(selectedIndex, color);
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  // Add button for custom color picker
                  _buildAddColorButton(context, selectedIndex, selectedColor),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddColorButton(
      BuildContext context, int selectedIndex, Color currentColor) {
    return GestureDetector(
      onTap: () {
        if (selectedIndex < 0) return;

        Color pickerColor = currentColor;

        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Select a Color',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (Color color) {
                    pickerColor = color;
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                    foregroundColor: Colors.deepPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Select'),
                  onPressed: () {
                    context
                        .read<CanvasCubit>()
                        .changeTextColor(selectedIndex, pickerColor);
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: const Icon(Icons.add, color: Colors.black54, size: 20),
      ),
    );
  }

  // --- Other unchanged methods below ---

  Widget _buildFontSizeControls(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSizeButton(
                context: context,
                icon: Icons.remove,
                onPressed: () => _changeFontSize(context, decrease: true),
              ),
              BlocBuilder<CanvasCubit, CanvasState>(
                builder: (context, state) {
                  final fontSize = state.textItems.isNotEmpty
                      ? state.textItems.last.fontSize.round()
                      : 16;
                  return Container(
                    constraints: const BoxConstraints(minWidth: 36),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$fontSize',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
              _buildSizeButton(
                context: context,
                icon: Icons.add,
                onPressed: () => _changeFontSize(context, decrease: false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFontFamilyControls(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Font',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: BlocBuilder<CanvasCubit, CanvasState>(
            builder: (context, state) {
              final currentFont = state.textItems.isNotEmpty
                  ? state.textItems.last.fontFamily
                  : 'Arial';

              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  menuWidth: 170,
                  value: currentFont,
                  items: items,
                  onChanged: (value) => _changeFontFamily(context, value),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSizeButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildFontStyleControls(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Style',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStyleButton(
                context: context,
                icon: Icons.format_bold,
                onPressed: () => _changeFontWeight(context, FontWeight.bold),
              ),
              const SizedBox(width: 8),
              _buildStyleButton(
                context: context,
                icon: Icons.format_italic,
                onPressed: () => _changeFontStyle(context, FontStyle.italic),
              ),
              const SizedBox(width: 8),
              _buildStyleButton(
                context: context,
                icon: Icons.format_clear,
                onPressed: () => _resetFontStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStyleButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  void _changeFontStyle(BuildContext context, FontStyle fontStyle) {
    final selectedIndex =
        context.read<CanvasCubit>().state.textItems.length - 1;
    if (selectedIndex >= 0) {
      context.read<CanvasCubit>().changeFontStyle(selectedIndex, fontStyle);
    }
  }

  void _changeFontWeight(BuildContext context, FontWeight fontWeight) {
    final selectedIndex =
        context.read<CanvasCubit>().state.textItems.length - 1;
    if (selectedIndex >= 0) {
      context.read<CanvasCubit>().changeFontWeight(selectedIndex, fontWeight);
    }
  }

  void _resetFontStyle(BuildContext context) {
    final selectedIndex =
        context.read<CanvasCubit>().state.textItems.length - 1;
    if (selectedIndex >= 0) {
      context
          .read<CanvasCubit>()
          .changeFontWeight(selectedIndex, FontWeight.normal);
      context
          .read<CanvasCubit>()
          .changeFontStyle(selectedIndex, FontStyle.normal);
    }
  }

  void _changeFontSize(BuildContext context, {required bool decrease}) {
    final selectedIndex =
        context.read<CanvasCubit>().state.textItems.length - 1;
    if (selectedIndex >= 0) {
      final currentSize =
          context.read<CanvasCubit>().state.textItems[selectedIndex].fontSize;
      final newSize = decrease ? currentSize - 2 : currentSize + 2;
      context.read<CanvasCubit>().changeFontSize(
        selectedIndex,
        newSize,
      );
    }
  }

  void _changeFontFamily(BuildContext context, String? fontFamily) {
    if (fontFamily != null) {
      final selectedIndex =
          context.read<CanvasCubit>().state.textItems.length - 1;
      if (selectedIndex >= 0) {
        context
            .read<CanvasCubit>()
            .changeFontFamily(selectedIndex, fontFamily);
      }
    }
  }
}
