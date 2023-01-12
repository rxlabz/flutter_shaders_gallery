import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import 'shader_painter.dart';

class SimpleShaderView extends StatelessWidget {
  final String assetKey;

  const SimpleShaderView({required this.assetKey, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ShaderBuilder(
      assetKey: assetKey,
      (context, shader, child) {
        shader
          ..setFloat(0, size.width)
          ..setFloat(1, size.height);

        return CustomPaint(
          size: size,
          painter: ShaderPainter(shader),
        );
      },
    );
  }
}
