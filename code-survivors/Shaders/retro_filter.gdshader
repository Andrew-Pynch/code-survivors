shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.1;
uniform float dither_size : hint_range(1.0, 8.0) = 4.0;
uniform float aberration_strength : hint_range(0.0, 5.0) = 0.5;
const mat4 dither_pattern = mat4(
    vec4(0.0, 8.0, 2.0, 10.0),
    vec4(12.0, 4.0, 14.0, 6.0),
    vec4(3.0, 11.0, 1.0, 9.0),
    vec4(15.0, 7.0, 13.0, 5.0)
) / 16.0;

float random(vec2 uv) {
    vec2 scaled_uv = uv * 0.3;
    return fract(sin(dot(scaled_uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float random2(vec2 uv) {
    vec2 scaled_uv = uv * 0.4;
    return fract(sin(dot(scaled_uv, vec2(78.233, 12.9898))) * 43758.5453123);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 original = texture(SCREEN_TEXTURE, uv);
 	COLOR = original;
    // Only process if the pixel is from the tilemap (checking if it's not transparent)
    if (original.a > 0.0) {
        vec4 color = original;
        vec4 color_r = texture(SCREEN_TEXTURE, uv + vec2(aberration_strength * 0.01, 0.0));
        vec4 color_b = texture(SCREEN_TEXTURE, uv - vec2(aberration_strength * 0.01, 0.0));

        color = mix(color,
            vec4(color_r.r, color.g, color_b.b, color.a),
            aberration_strength * 0.5);

        float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));

        float noise = random(uv + TIME * 0.5) * noise_strength;
        float dark_noise = random2(uv + TIME * 0.3) * 0.15;

        color.rgb += noise - noise_strength * 0.5;

        if (luminance < 0.3) {
            float darkness = 1.0 - luminance;
            float dark_grain = mix(dark_noise, -dark_noise, random(uv + TIME));
            color.rgb += dark_grain * (1.0 - darkness * 0.5);
        }

        vec2 dither_uv = FRAGCOORD.xy / dither_size;
        float dither = dither_pattern[int(mod(dither_uv.x, 4.0))][int(mod(dither_uv.y, 4.0))];
        color.rgb = floor(color.rgb * 4.0 + dither) / 4.0;

        vec3 dark = vec3(0.0, 0.05, 0.0);
        vec3 mid = vec3(0.2, 0.4, 0.1);
        vec3 highlight = vec3(0.8, 0.2, 0.1);

        luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
       
        COLOR = color;
    } else {
        // If it's not part of the tilemap (transparent), leave it unchanged
        COLOR = original;
    }
}