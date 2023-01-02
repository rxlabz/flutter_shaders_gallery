import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shaders_lab/extensions.dart';

import 'shader_painter.dart';

class InvertView extends StatefulWidget {
  const InvertView({super.key});

  @override
  State<InvertView> createState() => _InvertViewState();
}

class _InvertViewState extends State<InvertView> {
  ui.Image? image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Image.asset('assets/dash0.png')
        .image
        .resolve(createLocalImageConfiguration(context))
        .addListener(ImageStreamListener((info, _) {
      image = info.image;
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) => image == null
      ? const Center(child: CircularProgressIndicator())
      : Center(
          child: SizedBox(
            width: image!.width.toDouble(),
            height: image!.height.toDouble(),
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.fitWidth,
              child: ShaderBuilder(
                assetKey: 'shaders/invert.frag',
                (context, shader, child) {
                  shader
                    ..setFloat(0, image!.width.toDouble())
                    ..setFloat(1, image!.height.toDouble())
                    ..setImageSampler(0, image!);

                  return CustomPaint(
                    size: image!.size,
                    painter: ShaderPainter(shader),
                  );
                },
              ),
            ),
          ),
        );
}
