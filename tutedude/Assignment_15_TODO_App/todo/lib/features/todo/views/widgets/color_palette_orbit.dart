import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class ColorPaletteOrbit extends StatelessWidget {
  final ThemeController themeCtrl;
  final VoidCallback onClose;

  const ColorPaletteOrbit({
    super.key,
    required this.themeCtrl,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(12, (i) {
              double angle = (i * 30) * (pi / 180);
              return Transform.translate(
                offset: Offset(cos(angle) * 115, sin(angle) * 115),
                child: GestureDetector(
                  onTap: () {
                    themeCtrl.updateSeedColor(i);
                    onClose();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.palette[i],
                      border: Border.all(
                        color: themeCtrl.activeColorIndex == i
                            ? Colors.white
                            : Colors.transparent,
                        width: 3.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
