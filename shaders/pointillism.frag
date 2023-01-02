#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

layout (location = 0) uniform vec2 size;
layout (location = 1) uniform float numD;

uniform sampler2D img;

out vec4 fragColor;

// 5 points colors avg
vec4 avg(vec2 c1, vec2 c2, vec2 c3, vec2 c4, vec2 c5) {
  return (texture(img, c1) + texture(img, c2) + texture(img, c3) + texture(img, c4) + texture(img, c5)) / 5;
}

vec4 cell(float numDiv, vec2 position, vec2 size) {
  vec2 cellSize = size / numDiv;
  vec2 cc = cellSize / 2;

  vec2 p = position - (floor(position / cellSize) * cellSize);
  bool visible = vec2(step(length(p - cc), cc.y)) == vec2(1);

  if( !visible){
    return vec4(0);
  }

  vec2 tl = floor((position / size) * numDiv) / numDiv;
  vec2 tr = tl + ((vec2(cellSize.x, 0) / size) * numDiv) / numDiv;
  vec2 bl = tl + ((vec2(0, cellSize.y) / size) * numDiv) / numDiv;;
  vec2 br = tl + ((cellSize / size) * numDiv) / numDiv;

  vec2 c = tl + ((cc / size) * numDiv) / numDiv;

  return avg(c, tl, tr, bl, br);
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

