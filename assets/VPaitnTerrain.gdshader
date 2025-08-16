shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// Textures for material A, B, C, and the transition noise
group_uniforms textures;
uniform sampler2D texture_albedo_a : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_normal_a : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_orm_a : hint_roughness_g, filter_linear_mipmap, repeat_enable;
uniform float roughness_a : hint_range(0, 2) = 1.0;

uniform sampler2D texture_albedo_b : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_normal_b : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_orm_b : hint_roughness_g, filter_linear_mipmap, repeat_enable;
uniform float roughness_b : hint_range(0, 2) = 1.0;

uniform sampler2D texture_albedo_c : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_normal_c : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_orm_c : hint_roughness_g, filter_linear_mipmap, repeat_enable;
uniform float roughness_c : hint_range(0, 2) = 1.0;

uniform sampler2D texture_noise : source_color, filter_linear_mipmap, repeat_enable;

group_uniforms main_settings;
uniform vec4 albedo_a : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 albedo_b : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 albedo_c : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float normal_scale : hint_range(-16, 16) = 1.0;
uniform float ao_light_affect = 1.0;
uniform float roughness_control : hint_range(0, 2) = 1.0;
uniform float metallic_control : hint_range(0, 2) = 1.0;
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset;

group_uniforms blend_settings;
uniform float blend_threshold = 0.5;
uniform float blend_noise_intensity = 0.5;
uniform float blend_noise_scale = 2.0;
uniform float blend_softness = 0.5;
uniform vec4 blend_transition_color : source_color = vec4(0.0, 0.0, 0.0, 0.25);

varying vec2 noise_uv;

void vertex() {
    UV = UV * uv1_scale.xy + uv1_offset.xy;
    // Pre-calculate noise UV in vertex shader
    noise_uv = UV * blend_noise_scale;
}

void fragment() {
    vec2 base_uv = UV;

    // Get blend masks from vertex colors
    vec3 masks = COLOR.rgb;

    // Sample noise texture once
    float noise = texture(texture_noise, noise_uv).r * blend_noise_intensity;
    float threshold = clamp(blend_threshold + noise, 0.0, 1.0);

    // Calculate blend weights with early exit optimization
    float softness_range = blend_softness * 2.0;
    vec3 blend_weights = smoothstep(vec3(threshold - blend_softness),
                                   vec3(threshold + blend_softness),
                                   masks);

    // Normalize blend weights
    float total_blend = dot(blend_weights, vec3(1.0));
    blend_weights = (total_blend > 0.0) ? blend_weights / total_blend : vec3(1.0, 0.0, 0.0);

    // Sample all textures once and store
    vec4 albedo_tex_a = texture(texture_albedo_a, base_uv) * albedo_a;
    vec4 albedo_tex_b = texture(texture_albedo_b, base_uv) * albedo_b;
    vec4 albedo_tex_c = texture(texture_albedo_c, base_uv) * albedo_c;

    vec4 orm_tex_a = texture(texture_orm_a, base_uv);
    vec4 orm_tex_b = texture(texture_orm_b, base_uv);
    vec4 orm_tex_c = texture(texture_orm_c, base_uv);

    vec3 normal_tex_a = texture(texture_normal_a, base_uv).rgb;
    vec3 normal_tex_b = texture(texture_normal_b, base_uv).rgb;
    vec3 normal_tex_c = texture(texture_normal_c, base_uv).rgb;

    // Blend albedo
    vec3 albedo_mixed = albedo_tex_a.rgb * blend_weights.x +
                        albedo_tex_b.rgb * blend_weights.y +
                        albedo_tex_c.rgb * blend_weights.z;

    // Transition effect (simplified calculation)
    float transition_factor = 1.0 - smoothstep(blend_softness * 0.5,
                                              blend_softness * 1.5,
                                              abs(masks.r - threshold));
    transition_factor = clamp(transition_factor, 0.0, 1.0);

    ALBEDO = mix(albedo_mixed,
                 blend_transition_color.rgb,
                 transition_factor * min(blend_transition_color.a, 0.5));

    // Blend material properties using dot products for efficiency
    vec3 roughness_values = vec3(orm_tex_a.g * roughness_a,
                                orm_tex_b.g * roughness_b,
                                orm_tex_c.g * roughness_c);
    ROUGHNESS = dot(roughness_values, blend_weights) * roughness_control;

    METALLIC = dot(vec3(orm_tex_a.b, orm_tex_b.b, orm_tex_c.b), blend_weights) * metallic_control;

    // Blend normals
    NORMAL_MAP = normal_tex_a * blend_weights.x +
                 normal_tex_b * blend_weights.y +
                 normal_tex_c * blend_weights.z;
    NORMAL_MAP_DEPTH = normal_scale;

    // Blend AO
    AO = dot(vec3(orm_tex_a.r, orm_tex_b.r, orm_tex_c.r), blend_weights);
    AO_LIGHT_AFFECT = ao_light_affect;
}