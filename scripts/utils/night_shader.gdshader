shader_type canvas_item;

// Parâmetros ajustáveis no Inspector ou via script
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 night_color : source_color = vec4(0.1, 0.2, 0.45, 1.0); // Azul escuro
uniform float night_amount : hint_range(0.0, 1.0) = 1.0;             // 0 = Dia, 1 = Noite
uniform float brightness : hint_range(0.0, 2.0) = 2;              // Ajuste de brilho
uniform float contrast : hint_range(0.0, 2.0) = 1.1;                 // Ajuste de contraste

void fragment() {
    vec4 base = texture(screen_texture, SCREEN_UV);
    
    // Calcula a luminância (escala de cinza) da tela
    float gray = dot(base.rgb, vec3(0.299, 0.587, 0.114));
    
    // Tintura azul baseada no tom da noite
    vec3 tinted = vec3(gray) * night_color.rgb;
    
    // Aplica contraste e brilho
    vec3 night_result = (tinted - 0.5) * contrast + 0.5;
    night_result *= brightness;
    
    // Interpola do tom original para o tom de noite com base no night_amount
    COLOR.rgb = mix(base.rgb, night_result, night_amount);
    COLOR.a = base.a;
}