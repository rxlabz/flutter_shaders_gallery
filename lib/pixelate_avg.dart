import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shaders_lab/extensions.dart';

import 'shader_painter.dart';

const SHADER = 'shaders/pixelate_avg.frag';

class PixelateAvgView extends StatefulWidget {
  const PixelateAvgView({super.key});

  @override
  _PixelateAvgViewState createState() => _PixelateAvgViewState();
}

class _PixelateAvgViewState extends State<PixelateAvgView>
    with SingleTickerProviderStateMixin {
  ui.Image? image;

  double maxCell = 10;
  double numCell = 10;

  late final AnimationController anim;
  late final CurvedAnimation curved;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
      lowerBound: 1,
      upperBound: 256,
      value: 1,
    );
    curved = CurvedAnimation(parent: anim, curve: Curves.elasticOut);
  }

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
        : AnimatedBuilder(
            animation: anim,
            builder: (context, _) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 108.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Slider(
                            value: numCell,
                            min: 1,
                            max: 128,
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
                    child: Center(
                      child: SizedBox(
                        width: image!.width.toDouble(),
                        height: image!.height.toDouble(),
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.fitWidth,
                          child: ShaderBuilder(
                            assetKey: 'shaders/pixelate_avg.frag',
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
                  ),
                ],
              );
            },
          );
  }
}
