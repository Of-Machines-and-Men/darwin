shader_type canvas_item;

uniform float wobble_strength : hint_range(0.0, 5.0) = 2.0;
uniform float wobble_frequency : hint_range(1.0, 20.0) = 8.0;
uniform float border_width : hint_range(1.0, 10.0) = 3.0;
uniform vec4 border_color : source_color = vec4(0.1, 0.08, 0.05, 1.0);
uniform vec4 fill_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec2 rect_size = vec2(300.0, 200.0);

void fragment() {
    vec2 uv = UV;

    float bw = border_width / rect_size.x;
    float bh = border_width / rect_size.y;

    float wobble_l = sin(uv.y * wobble_frequency) * (wobble_strength / rect_size.x);
    float wobble_r = sin(uv.y * wobble_frequency + 2.1) * (wobble_strength / rect_size.x);
    float wobble_t = sin(uv.x * wobble_frequency + 1.0) * (wobble_strength / rect_size.y);
    float wobble_b = sin(uv.x * wobble_frequency + 3.2) * (wobble_strength / rect_size.y);

    bool on_border =
        uv.x < bw + wobble_l ||
        uv.x > 1.0 - bw + wobble_r ||
        uv.y < bh + wobble_t ||
        uv.y > 1.0 - bh + wobble_b;

    COLOR = on_border ? border_color : fill_color;
}