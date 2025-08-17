shader_type spatial;

uniform float progress : hint_range(0.0, 1.0);
uniform float noise_density = 60.0;
uniform float beam_size : hint_range(0.01, 0.15);
uniform vec4 color : source_color = vec4(0.0, 1.02, 1.2, 1.0);
uniform sampler2D albedo_texture; // Define texture uniform

// Random function for noise generation
vec2 random(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1, 311.7)),
              dot(uv, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

// Noise function
float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);
    vec2 blur = smoothstep(0.0, 1.0, uv_fract);
    return mix(mix(dot(random(uv_index + vec2(0.0, 0.0)), uv_fract - vec2(0.0, 0.0)),
                   dot(random(uv_index + vec2(1.0, 0.0)), uv_fract - vec2(1.0, 0.0)), blur.x),
               mix(dot(random(uv_index + vec2(0.0, 1.0)), uv_fract - vec2(0.0, 1.0)),
                   dot(random(uv_index + vec2(1.0, 1.0)), uv_fract - vec2(1.0, 1.0)), blur.x), blur.y) * 0.5 + 0.5;
}

void fragment() {
    // Sample the albedo texture using UV
    vec4 tex = texture(albedo_texture, UV);
    
    // Compute noise based on UV and noise_density, modulated by UV.y for vertical effect
    float noise_value = noise(UV * noise_density) * UV.y;
    
    // Calculate beam and dissolve thresholds
    float d1 = step(progress, noise_value);
    float d2 = step(progress - beam_size, noise_value);
    
    // Compute beam color
    vec3 beam = vec3(d2 - d1) * color.rgb;
    
    // Set albedo (color) and add beam
    ALBEDO = tex.rgb + beam;
    
    // Set alpha for dissolve effect
    ALPHA = tex.a * d2;
}