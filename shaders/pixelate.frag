#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout (location = 0) uniform vec2 size;
layout (location = 1) uniform float cSize;

uniform sampler2D img;

out vec4 fragColor;

// pixelate
void main() {
  vec2 uv = FlutterFragCoord().xy / size;
  vec2 cellSize = vec2(size/cSize);
  vec2 pxUv = round( uv * cellSize ) / cellSize;

  fragColor = texture(img, pxUv);
}

