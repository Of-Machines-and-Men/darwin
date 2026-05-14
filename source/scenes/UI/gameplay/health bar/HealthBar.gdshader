shader_type canvas_item;

uniform sampler2D mask_texture : source_color;

void fragment() {
    float mask = texture(mask_texture, UV).r;
    COLOR = vec4(COLOR.rgb, COLOR.a * mask);
}