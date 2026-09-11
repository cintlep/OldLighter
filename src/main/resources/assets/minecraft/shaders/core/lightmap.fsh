#version 330

layout(std140) uniform LightmapInfo {
    float SkyFactor;
    float BlockFactor;
    float NightVisionFactor;
    float DarknessScale;
    float BossOverlayWorldDarkeningFactor;
    float BrightnessFactor;
    vec3 BlockLightTint;
    vec3 SkyLightColor;
    vec3 AmbientColor;
    vec3 NightVisionColor;
    float AmbientLightFactor;
    float TintedAmbientDimension;
} lightmapInfo;

in vec2 texCoord;
out vec4 fragColor;

float get_brightness(float level, float floorFactor) {
    float curved_level = level / (4.0 - 3.0 * level);
    return mix(curved_level, 1.0, floorFactor);
}

vec3 cubic_color(float bb) {
    return vec3(
            bb,
            bb * ((bb * 0.6 + 0.4) * 0.6 + 0.4),
            bb * (bb * bb * 0.6 + 0.4)
    );
}

vec3 boostSaturation(vec3 color, float factor) {
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    return luma + (color - luma) * factor;
}

void main() {
    float ambientForCurve = lightmapInfo.TintedAmbientDimension != 0.0 ? 0.0 : lightmapInfo.AmbientLightFactor;
    float satFactor = mix(0.7, 1.0, clamp(lightmapInfo.NightVisionFactor, 0.0, 1.0));
    bool isAmbientZero = lightmapInfo.AmbientLightFactor == 0.0;
    float block_brightness = get_brightness(floor(texCoord.x * 16) / 15, ambientForCurve) * lightmapInfo.BlockFactor;
    float sky_brightness = get_brightness(floor(texCoord.y * 16) / 15, ambientForCurve) * lightmapInfo.SkyFactor;
    vec3 block_color = cubic_color(block_brightness);
    vec3 color = lightmapInfo.TintedAmbientDimension != 0.0
    ? clamp(lightmapInfo.AmbientColor * 1.0 + block_color * 0.6, 0.0, 1.0)
    : mix(block_color, lightmapInfo.AmbientColor, lightmapInfo.AmbientLightFactor);
    color += lightmapInfo.SkyLightColor * sky_brightness;
    color = clamp(color, 0.0, 1.0);
    color = mix(color, vec3(0.75), 0.04);

    if (isAmbientZero) {
        vec3 darkened_color = color * vec3(0.7, 0.6, 0.6);
        color = mix(color, darkened_color, lightmapInfo.BossOverlayWorldDarkeningFactor);
    }

    if (lightmapInfo.NightVisionFactor > 0.0) {
        vec3 block_color_full = cubic_color(get_brightness(1.0, ambientForCurve) * lightmapInfo.BlockFactor);
        vec3 bright_color = lightmapInfo.TintedAmbientDimension != 0.0
        ? clamp(lightmapInfo.AmbientColor * 1.0 + block_color_full * 0.6, 0.0, 1.0)
        : clamp(mix(block_color_full, lightmapInfo.AmbientColor, lightmapInfo.AmbientLightFactor) + lightmapInfo.SkyLightColor * 1.0, 0.0, 1.0);
        color = mix(color, bright_color, lightmapInfo.NightVisionFactor);
    }

    if (isAmbientZero) {
        color = clamp(color - vec3(lightmapInfo.DarknessScale), 0.0, 1.0);
    }

    color = clamp(color, 0.0, 1.0);
    vec3 nx = 1.0 - color;
    vec3 gammaPerChannel = 1.0 - nx * nx * nx * nx;
    float maxComponent = max(max(color.r, color.g), color.b);
    vec3 gammaMaxChannel = color;
    if (maxComponent > 0.0) {
        float maxInverted = 1.0 - maxComponent;
        float maxScaled = 1.0 - maxInverted * maxInverted * maxInverted * maxInverted;
        gammaMaxChannel = color * (maxScaled / maxComponent);
    }
    gammaMaxChannel = clamp(boostSaturation(gammaMaxChannel, satFactor), 0.0, 1.0);
    float blockDominance = (block_brightness + sky_brightness) > 0.0
    ? block_brightness / (block_brightness + sky_brightness)
    : 0.0;
    vec3 notGammaColor = mix(gammaMaxChannel, gammaPerChannel, blockDominance);
    color = clamp(boostSaturation(color, satFactor), 0.0, 1.0);
    color = mix(color, notGammaColor, lightmapInfo.BrightnessFactor);
    color = mix(color, vec3(0.75), 0.04);
    fragColor = vec4(color, 1.0);
}