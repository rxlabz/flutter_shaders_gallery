import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import 'extensions.dart';
import 'shader_painter.dart';

class PixelateView extends StatefulWidget {
  const PixelateView({super.key});

  @override
  State createState() => _PixelateViewState();
}

class _PixelateViewState extends State<PixelateView>
    with SingleTickerProviderStateMixin {
  ui.Image? image;

  double numCell = 10;

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
  Widget build(BuildContext context) {
    return image == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 108.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Slider(
                        value: numCell,
                        min: 1,
                        max: 256,
                        divisions: 100,
                        onChanged: (value) => setState(
                          () => numCell = value.roundToDouble(),
                        ),
                      ),
                    ),
                    Text("$numCell"),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: image!.width.toDouble(),
                  height: image!.height.toDouble(),
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.fitWidth,
                    child: ShaderBuilder(
                      assetKey: 'shaders/pixelate.frag',
                      (context, shader, child) {
                        shader
                          ..setFloat(0, image!.width.toDouble())
                          ..setFloat(1, image!.height.toDouble())
                          ..setFloat(2, numCell)
                          ..setImageSampler(0, image!);

                        return CustomPaint(
                          size: image!.size,
                          painter: ShaderPainter(shader),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
