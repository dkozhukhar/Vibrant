#version 110

varying vec2 p0;
varying vec2 p1;

void main()
{
	p0 = gl_MultiTexCoord0.xy;
	p1 = gl_MultiTexCoord1.xy;	
	
	gl_Position = ftransform();
}
