#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout(location = 0) uniform vec2 size;

out vec4 fragColor;

void main() {
  vec2 st = FlutterFragCoord().xy / size;

  fragColor = vec4(vec3(st.x),1.0);
}
