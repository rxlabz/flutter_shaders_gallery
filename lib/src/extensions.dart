import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/flutter_shaders.dart';

import 'shader_painter.dart';

Widget handleNullImage(Image? image, Widget Function(Image) builder) =>
    image == null
        ? const Center(child: CircularProgressIndicator())
        : builder(image);

ShaderBuilder pixelateBuilder({
  required String shaderKey,
  required Image image,
  required double numCell,
}) =>
    ShaderBuilder(
      assetKey: shaderKey,
      (context, shader, child) {
        shader
          ..setFloat(0, image.width.toDouble())
          ..setFloat(1, image.height.toDouble())
          ..setFloat(2, numCell)
          ..setImageSampler(0, image);

        return CustomPaint(
          size: image.size,
          painter: ShaderPainter(shader),
        );
      },
    );

extension Helpers on Image {
  Size get size => Size(width.toDouble(), height.toDouble());
}
