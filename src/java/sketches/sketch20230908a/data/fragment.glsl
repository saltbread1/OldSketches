#ifdef GL_ES
precision mediump float;
#endif

const float NOISE_SCALE = 8.;
const int OCTAVES = 5;

uniform vec2 resolution;
uniform sampler2D texture;

float random(const vec2 st)
{
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(const vec2 v)
{
    vec2 i = floor(v);
    vec2 f = fract(v);
    vec2 u = f*f*(3.-2.*f);
    return mix( mix( random( i + vec2(0., 0.) ),
    random( i + vec2(1., 0.) ), u.x),
    mix( random( i + vec2(0., 1.) ),
    random( i + vec2(1., 1.) ), u.x), u.y);
}

float fbm(const vec2 v)
{
    vec2 p = v;
    float result = 0.0;
    float amplitude = .8;

    for (int i = 0; i < OCTAVES; i++)
    {
        result += amplitude * noise(p);
        amplitude *= 0.5;
        p *= 2.0;
    }

    return result;
}

vec2 domainWarp(const vec2 v)
{
    vec2 n_offsets[6];
    n_offsets[0] = vec2(0.6, 1.2);
    n_offsets[1] = vec2(4.1, 3.4);
    n_offsets[2] = vec2(9.4, 9.1);
    n_offsets[3] = vec2(1.6, 8.2);
    n_offsets[4] = vec2(0.5, 0.9);
    n_offsets[5] = vec2(4.4, 3.9);

    vec2 n_val = vec2(0);
    for (int i = 0; i < 3; i++)
    {
        vec2 val = n_val * 4. + v;
        float n1 = fbm(val + n_offsets[i*2]);
        float n2 = fbm(val + n_offsets[i*2+1]);
        n_val = vec2(n1, n2);
    }
    return n_val;
}

void main()
{
    vec2 st = gl_FragCoord.xy/resolution.y;

    vec2 n_val = domainWarp(st*NOISE_SCALE);
    float r = sqrt(1.-n_val.x) + n_val.y*.44;
    float g = n_val.y*n_val.y;
    float b = n_val.x*n_val.y*1.2;
    vec3 col = vec3(r, g, b);

    vec3 normal = normalize(vec3(n_val.y, .9, n_val.x));
    vec3 light = normalize(vec3(.8, .1, -.2));
    float diffuse = .3+.7*dot(normal, light);
    vec4 texCol = texture2D(texture, gl_FragCoord.xy/resolution);
    col *= diffuse*diffuse*3.2;
    col *= texCol.xyz;
    col = col*col;

    gl_FragColor = vec4(col, texCol.w);
}
