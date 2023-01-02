#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout(location = 0) uniform vec2 size;

out vec4 fragColor;

void main() {
  vec2 st = gl_FragCoord.xy / size;

  vec3 color = smoothstep(0.001, 0.0, abs(st.y-st.x)) * vec3(1.0, 1.0, 1.0);

  // horizontal
  color += smoothstep(0.01, 0.0, abs(st.y- 0.3)) * vec3(1.0, .0, 1.0);

  // vertical
  color += smoothstep(0.005, 0.0, abs(st.x- 0.3)) * vec3(.0, 1.0, 1.0);

  fragColor = vec4(color,1.0);

}
