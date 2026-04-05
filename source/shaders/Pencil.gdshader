shader_type canvas_item;

uniform float border_width : hint_range(1.0, 20.0) = 4.0;
uniform float roughness : hint_range(0.0, 8.0) = 3.0;
uniform float frequency : hint_range(1.0, 40.0) = 20.0;
uniform vec4 border_color : source_color = vec4(0.08, 0.05, 0.02, 1.0);
uniform vec4 fill_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec2 rect_size = vec2(300.0, 200.0);

float noise(float x) {
    return fract(sin(x * 127.1 + 311.7) * 43758.5453);
}

float smooth_noise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(noise(i), noise(i + 1.0), u);
}

float rough_noise(float x) {
    return smooth_noise(x) * 0.5
         + smooth_noise(x * 2.1) * 0.25
         + smooth_noise(x * 4.3) * 0.125;
}

void fragment() {
    vec2 uv = UV;

    float bw = border_width / rect_size.x;
    float bh = border_width / rect_size.y;

    float disp_l = (rough_noise(uv.y * frequency) - 0.5) * (roughness / rect_size.x);
    float disp_r = (rough_noise(uv.y * frequency + 5.7) - 0.5) * (roughness / rect_size.x);
    float disp_t = (rough_noise(uv.x * frequency + 2.3) - 0.5) * (roughness / rect_size.y);
    float disp_b = (rough_noise(uv.x * frequency + 8.1) - 0.5) * (roughness / rect_size.y);

    bool on_border =
        uv.x < bw + disp_l ||
        uv.x > 1.0 - bw + disp_r ||
        uv.y < bh + disp_t ||
        uv.y > 1.0 - bh + disp_b;

    COLOR = on_border ? border_color : fill_color;
}