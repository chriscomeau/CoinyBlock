//
//  ShaderLava.m
//  CoinBlock
//
//  Created by Chris Comeau on 2017-11-09.
//  Copyright © 2017 Skyriser Media. All rights reserved.
//


//https://developer.apple.com/documentation/spritekit/skshader

/*

When browsing Shadertoy, you’ll notice certain variables that aren’t available to you, or that break your script. Here are the most common ones I’ve seen, and how to use them in SpriteKit.

iGlobalTime	u_time
iResolution	u_sprite_size
fragCoord.xy	gl_FragCoord.xy
iChannelX	SKUniform with name of “iChannelX” containing SKTexture
fragColor	gl_FragColor

*/


/*
https://stackoverflow.com/questions/26072230/applying-a-custom-skshader-to-skscene-that-pixelates-the-whole-rendered-scene-in
In order to get your .shader running on SKScene, you need to set shouldEnableEffects to true on the scene (same thing goes for SKEffectNode).

*/

/*
You can specify which renderer your device uses, for example, forcing a Metal enabled device to use OpenGL for debugging purposes, by adding a PrefersOpenGL key with a value of true to your app's Info.plist as shown in Figure 1.

*/


//http://battleofbrothers.com/sirryan/understanding-shaders-in-spritekit

//just green 1
#if 1
void main(void) {

    gl_FragColor = vec4(0.0,1.0,0.0,1.0);
}
#endif

//just green 2
#if 0
void main() {

    // Find the pixel at the coordinate of the actual texture
    vec4 val = texture2D(u_texture, v_tex_coord);

    // If the alpha value of that pixel is 0.0
    if (val.a == 0.0) {

        // Turn the pixel green
        gl_FragColor = vec4(0.0,1.0,0.0,1.0);

    } else {

        // Otherwise, keep the original color
        gl_FragColor = val;

    }
}

#endif


//water 1
#if 0
void main(void) {

    vec2 uv = v_tex_coord;

    uv.y += (cos((uv.y + (u_time * 0.04)) * 45.0) * 0.0019) +
    (cos((uv.y + (u_time * 0.1)) * 10.0) * 0.002);

    uv.x += (sin((uv.y + (u_time * 0.07)) * 15.0) * 0.0029) +
    (sin((uv.y + (u_time * 0.1)) * 15.0) * 0.002);

    gl_FragColor = texture2D(u_texture, uv);
}
#endif

//water 2
#if 0
void main(void)
{
    vec2 uv = v_tex_coord;

    uv.y += (sin((uv.y + (u_time * 0.10)) * 85.0) * 0.0025*movement) +
    (sin((uv.y + (u_time * 0.15+(movement/10.0))) * 18.0) * 0.005);

    uv.x += (sin((uv.y + (u_time * 0.08)) * 55.0) * 0.0029*movement) +
    (sin((uv.y + (u_time * 0.2+(movement/10.0))) * 15.0) * 0.005);

    vec4 texColor = texture2D(customTexture,uv);
    gl_FragColor = texColor;
}
#endif
