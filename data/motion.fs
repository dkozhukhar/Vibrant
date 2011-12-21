#version 110
uniform sampler2D tex;
uniform sampler2D hud;
uniform sampler2D vel;

uniform mat4 currentProjModelviewInverse;
uniform mat4 previousProjModelview;


uniform vec4 texc;
uniform vec4 hudc;
uniform vec4 velc;
	            

varying vec2 p0;
varying vec2 p1;


const float PI = 3.14159265;

void main()
{
	vec4 currentPos = vec4(p0.x * 2.0 - 1.0, (1.0 - p0.y) * 2.0 - 1.0, 0.0, 1.0);
		
	
	// world position
	vec4 worldPos = currentProjModelviewInverse * currentPos;
	
	vec2 dPos = texture2D(vel, p0 * velc.zw).xy;
	dPos = (dPos - 0.5) * 10.0;
	dPos = vec2(0.0);
	
	vec4 worldPosPrevious = worldPos - vec4(dPos, 0.0, 0.0);
	
	vec4 previousPos = previousProjModelview * worldPosPrevious;
	
	previousPos = vec4(0.5 * previousPos.x + 0.5, 0.5 + previousPos.y * 0.5, 0.0, 1.0);
	
	vec2 velocity = (currentPos.xy - previousPos.xy);

	vec2 mov = velocity * 0.1;
	//vec2 mov = vec2(0.1, 0.0);
	
	/*
	vec3 res = vec3(0.0);
		
	for (int i = 0; i <= 20; ++i)
	{
		float fi = float(i) - 10.0;
		
		vec2 tc = clamp(p0 + mov * fi / 11.0, 0.0, 0.999) * texc.zw;
	
		res += pow(texture2D(tex, tc).rgb, vec3(2.2));
	}
	vec3 color = pow(res / 21.0, vec3(1.0 / 2.2));
	*/
	
	
	
	vec2 tc = clamp(p0, 0.0, 1.0) * texc.zw;;
	vec2 ta = clamp(p0 + mov, 0.0, 1.0) * texc.zw;;
	vec3 color = texture2D(tex, tc).rgb + texture2D(tex, ta).rgb;
	
	vec4 h = texture2D(hud, p1);
	
	
	gl_FragColor = vec4(mix(color, h.rgb, vec3(h.a)), 1.0);
	//gl_FragColor = vec4(h.rgb, 1.0);
}

