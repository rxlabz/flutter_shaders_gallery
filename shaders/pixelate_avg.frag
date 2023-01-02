#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout (location = 0) uniform vec2 size;
layout (location = 1) uniform float numD;

uniform sampler2D img;

out vec4 fragColor;

vec4 cell(float numDiv, vec2 position, vec2 size) {

  vec2 cellSize = size / numDiv;
  vec2 pUv = floor((position / size) * numDiv) / numDiv;

  // cell center
  vec2 topLeft = pUv;
  vec2 topRight = pUv + ((vec2(cellSize.x, 0) / size) * numDiv) / numDiv;
  vec2 bottomLeft = pUv + ((vec2(0, cellSize.y) / size) * numDiv) / numDiv;;
  vec2 bottomRight = pUv + ((cellSize / size) * numDiv) / numDiv;
  vec2 center = pUv + ((cellSize / 2 / size) * numDiv) / numDiv;

  // 5 points colors average
  vec4 avg = (texture(img, topLeft) + texture(img, bottomLeft) + texture(img, topRight) + texture(img, bottomRight) + texture(img, center)) / 5;

  return avg ;
}

// pointillism
void main() {
  vec2 uv = FlutterFragCoord().xy / size;
  if (numD > 127) {
    fragColor = texture(img, uv);
    return;
  }

  fragColor = cell(numD, FlutterFragCoord().xy, size);
}

