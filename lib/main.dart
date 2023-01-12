import 'package:flutter/material.dart';

import 'invert.dart';
import 'pixelate.dart';
import 'pixelate_avg.dart';
import 'pointillism.dart';
import 'pointillism_transition.dart';
import 'simple_shader.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.amber,
            brightness: Brightness.dark,
            backgroundColor: Colors.grey.shade900,
          ),
          useMaterial3: true,
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      );
}

enum ShaderType {
  gradientH(SimpleShaderView(assetKey: 'shaders/gradient_h.frag')),
  gradient(SimpleShaderView(assetKey: 'shaders/gradient.frag')),
  invert(InvertView()),
  line(SimpleShaderView(assetKey: 'shaders/lines.frag')),
  pixelate(PixelateView()),
  pixelateAvg(PixelateAvgView()),
  animatedPixelate(AnimatedShaderView('shaders/pixelate_avg.frag')),
  pointillism(PointillismView()),
  animatedPointillism(AnimatedShaderView('shaders/pointillism.frag')),
  ;

  final Widget view;
  const ShaderType(this.view);
}

final ValueNotifier<ShaderType> _selection =
    ValueNotifier(ShaderType.values.first);

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      endDrawer: Drawer(
        child: Builder(builder: (context) {
          return ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Shaders', style: textTheme.titleLarge),
                ),
              ),
              ...ShaderType.values.map(
                (e) => TextButton(
                  onPressed: () {
                    _selection.value = e;
                    Scaffold.of(context).closeEndDrawer();
                  },
                  child: Text(e.name),
                ),
              )
            ],
          );
        }),
      ),
      body: ValueListenableBuilder(
        valueListenable: _selection,
        builder: (context, value, _) => ShaderView(value),
      ),
    );
  }
}

class ShaderView extends StatelessWidget {
  final ShaderType type;

  const ShaderView(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        type.view,
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Icon(Icons.list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        )
      ],
    );
  }
}
