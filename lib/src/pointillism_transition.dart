import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import 'shader_painter.dart';

//const SHADER = 'shaders/pointillism.frag';

const images = [
  'assets/dash0.png',
  'assets/dash1.png',
  'assets/dash2.png',
  'assets/dash3.png',
];

class AnimatedShaderView extends StatefulWidget {
  final String shaderKey;

  const AnimatedShaderView(this.shaderKey, {super.key});

  @override
  State createState() => _AnimatedShaderViewState();
}

class _AnimatedShaderViewState extends State<AnimatedShaderView>
    with SingleTickerProviderStateMixin {
  ui.Image? image;

  int index = 0;

  late final AnimationController anim;
  late final CurvedAnimation curved;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      lowerBound: 1,
      upperBound: 128,
      value: 1,
    );

    anim.addStatusListener(onAnimationStatus);
    curved = CurvedAnimation(parent: anim, curve: Curves.easeInOutSine);
  }

  void onAnimationStatus(status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          return anim.reverse();
        }
      });
      return;
    }

    if (status == AnimationStatus.dismissed) {
      setState(() => index++);
      loadImage(images[index % images.length]);
      //anim.forward();
    }
  }

  void loadImage(String assetKey) {
    image = null;

    Image.asset(assetKey)
        .image
        .resolve(createLocalImageConfiguration(context))
        .addListener(ImageStreamListener((info, _) {
      image = info.image;
      setState(() {});
      anim.forward();
    }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loadImage(images[index % images.length]);
  }

  @override
  void dispose() {
    anim.removeStatusListener(onAnimationStatus);
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return image == null
        ? const Center(child: CircularProgressIndicator())
        : AnimatedBuilder(
            animation: curved,
            builder: (context, _) {
              double numCell = anim.value.roundToDouble();
              return Center(
                child: SizedBox(
                  width: image!.width.toDouble(),
                  height: image!.height.toDouble(),
                  child: RepaintBoundary(
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      child: ShaderBuilder(
                        assetKey: widget.shaderKey,
                        (context, shader, child) {
                          shader
                            ..setFloat(0, image!.width.toDouble())
                            ..setFloat(1, image!.height.toDouble())
                            ..setFloat(2, numCell)
                            ..setImageSampler(0, image!);

                          return CustomPaint(
                            size: Size(image!.width.toDouble(),
                                image!.height.toDouble()),
                            painter: ShaderPainter(shader),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
