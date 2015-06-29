#version 110
uniform sampler2D tex;
uniform vec3 globalColor;

void main()
{
	vec2 p0 = gl_TexCoord[0].xy;	
	
	vec4 blur6 = texture2D(tex, p0, 6.0);
	vec4 blur5 = texture2D(tex, p0, 5.0);
	vec4 blur4 = texture2D(tex, p0, 4.0);
	vec4 blur3 = texture2D(tex, p0, 3.0);
	vec4 blur2 = texture2D(tex, p0, 2.0);
	vec4 blur1 = texture2D(tex, p0, 1.0);
	vec4 blur0 = texture2D(tex, p0);

    vec4 around = 0.5 * blur1 + 0.3 * blur2 + 0.2 * blur3;
	vec4 color = blur0 + (blur0 - around) * 0.12;

	color = color + 0.1 * blur2 + 0.2 * blur3 + 0.3 * blur4 + 0.2 * blur5 + 0.1 * blur6;
		
	gl_FragColor = vec4(color.xyz * globalColor, 1.0);
}

