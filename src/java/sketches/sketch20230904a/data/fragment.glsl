#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265;
const float TAU = PI*2.;

uniform vec2 resolution;

float cross2D(const vec2 a, const vec2 b)
{
    return a.x * b.y - a.y * b.x;
}

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

float getQuadValue(vec2 v1, vec2 v2, vec2 v3, vec2 v4, vec2 target)
{
    vec2 e1 = target - v1;
    vec2 e2 = target - v2;
    vec2 e3 = target - v3;
    vec2 e4 = target - v4;

    vec2 e12 = v2 - v1;
    vec2 e23 = v3 - v2;
    vec2 e34 = v4 - v3;
    vec2 e41 = v1 - v4;

    vec4 crossVal = vec4(cross2D(e1, e12), cross2D(e2, e23), cross2D(e3, e34), cross2D(e4, e41));
    vec4 inv = vec4(1.) / crossVal;
    float val = dot(inv, vec4(80, 80, 6, 6))*.08;

    return abs(val);
}

void main()
{
    vec2 st = abs(gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x, resolution.y);

    vec2 v1 = vec2(.29, .71);
    vec2 v2 = vec2(.32, .24);
    vec2 v3 = vec2(.74, .16);
    vec2 v4 = vec2(.92, .85);

    float val = getQuadValue(v1, v2, v3, v4, st);

    float r = 1. - noise(vec2(val, .4));
    float g = pow(noise(vec2(val, 1.)), 2.);
    float b = noise(vec2(val, .8));
    vec3 col = vec3(r, g, b) * 2.6 - .9;

    float e = 8./min(resolution.x, resolution.y);
    vec3 normal = normalize(vec3(
    getQuadValue(v1+vec2(-e,0.), v2+vec2(e,0.), v3+vec2(e,0.), v4+vec2(e,0.), st),
    e,
    getQuadValue(v1+vec2(0.,-e), v2+vec2(0.,-e), v3+vec2(0.,e), v4+vec2(0.,-e), st)));
    vec3 light = normalize(vec3(.9, .2, -.4));
    float diffuse = clamp(dot(normal, light), 0., 1.);
    col *= diffuse*diffuse*4.4;
    col = col*col*1.6;

    gl_FragColor = vec4(col, 1.);
}
