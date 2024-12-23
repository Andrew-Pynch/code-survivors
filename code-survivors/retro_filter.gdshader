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

// Additional random function for different grain pattern
float random2(vec2 uv) {
    vec2 scaled_uv = uv * 0.4;
    return fract(sin(dot(scaled_uv, vec2(78.233, 12.9898))) * 43758.5453123);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(SCREEN_TEXTURE, uv);
    vec4 color_r = texture(SCREEN_TEXTURE, uv + vec2(aberration_strength * 0.01, 0.0));
    vec4 color_b = texture(SCREEN_TEXTURE, uv - vec2(aberration_strength * 0.01, 0.0));
    
    color = mix(color, 
        vec4(color_r.r, color.g, color_b.b, color.a),
        aberration_strength * 0.5);
    
    // Calculate base luminance
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Create two different noise patterns
    float noise = random(uv + TIME * 0.5) * noise_strength;
    float dark_noise = random2(uv + TIME * 0.3) * 0.15; // Additional noise for dark areas
    
    // Apply normal noise
    color.rgb += noise - noise_strength * 0.5;
    
    // Apply special noise treatment for dark areas
    if (luminance < 0.3) {
        float darkness = 1.0 - luminance;
        float dark_grain = mix(dark_noise, -dark_noise, random(uv + TIME)); // Creates both black and white grain
        color.rgb += dark_grain * (1.0 - darkness * 0.5); // Less effect in completely black areas
    }
    
    vec2 dither_uv = FRAGCOORD.xy / dither_size;
    float dither = dither_pattern[int(mod(dither_uv.x, 4.0))][int(mod(dither_uv.y, 4.0))];
    color.rgb = floor(color.rgb * 4.0 + dither) / 4.0;
    
    vec3 dark = vec3(0.0, 0.05, 0.0);
    vec3 mid = vec3(0.2, 0.4, 0.1);
    vec3 highlight = vec3(0.8, 0.2, 0.1);
    
    luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(dark, mid, step(0.3, luminance));
    color.rgb = mix(color.rgb, highlight, step(0.7, luminance));
    
    COLOR = color;
}