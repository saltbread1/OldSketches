#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265;
const float TAU = PI*2.;

uniform vec2 resolution;
uniform float time;

float triangle(vec2 st, float el)
{
    float e1 = smoothstep(-.015, .013, st.x);
    float e2 = smoothstep(-.015, .013, st.y);
    float e3 = smoothstep(-.015, .013, el-(st.x+st.y));
    return e1*e2*e3;
}

mat2 rotate2d(float rad)
{
    return mat2(cos(rad), -sin(rad), sin(rad), cos(rad));
}

float random(vec2 st)
{
    return fract(sin(dot(st.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    vec2 st = (gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x, resolution.y);
    vec2 stf = abs(st);
    float w = ((pow(sin((stf.x+stf.y)*2.4+time*1.8),3.)-1.)*.044+1.)*.035;
    float el = w+length(stf.x+stf.y)*.02;
    float s = time*.34;
    float a = floor(stf.x/el)*s;
    float b = floor(stf.y/el)*s*1.1;
    float xor = floor(mod((mod(a, 2.)+mod(b, 2.)), 2.) + mod((mod(floor(a/2.), 2.)+mod(floor(b/2.), 2.)), 2.)*2.);
    float r = float(mod(xor, 4.));
    float c = max(triangle(rotate2d(PI/2.*r)*(mod(stf, el)-vec2(el/2.))+vec2(el/2.), el)*w*w*425., .12);
    
    gl_FragColor = vec4(vec3(c*random(floor(st*400.)*time+1.)*2.6), 1.);
}