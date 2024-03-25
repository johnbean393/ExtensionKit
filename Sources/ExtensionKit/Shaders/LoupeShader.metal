//
//  LoupeViewShaders.metal
//
//
//  Created by Bean John on 25/3/2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[stitchable]] half4 loupe(float2 pos, SwiftUI::Layer l, float2 s, float2 touch) {
	float maxDistance = 0.05;
	float2 uv = pos / s;
	float2 center = touch / s;
	float2 delta = uv - center;
	float aspectRatio = s.x / s.y;
	float distance = (delta.x * delta.x) + (delta.y * delta.y) / aspectRatio;
	float totalZoom = 1;
	if (distance < maxDistance) {
		totalZoom /= 2;
		totalZoom += distance * 10;
	}
	float2 newPos = delta * totalZoom + center;
	return l.sample(newPos * s);
}

