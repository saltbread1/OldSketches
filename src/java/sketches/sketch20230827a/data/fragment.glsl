#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.14159265;
const float TAU = PI*2.;

uniform vec2 resolution;
uniform float time;

varying vec4 vertColor;

void main()
{
    vec2 st = (gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x, resolution.y);
    float rad = atan(st.y, st.x);
    float val1 = (cos(rad+PI+time*.6)+1.)/2.;
    float val2 = ((cos((val1 + sqrt(dot(st, st))*1.6)*8.+time*10.))+1.)/2.;
    float val = mix(val1, val2, 1.-pow((sin(time)+1.)/2.,2.));
    float r = val*2.4*vertColor.x;
    float g = val*1.6*vertColor.y;
    float b = sqrt(val)*vertColor.z;
    float a = 1. - pow(clamp(sqrt(dot(st,st)), 0., 1.), 10.);
    gl_FragColor = vec4(r, g, b, a);
}
