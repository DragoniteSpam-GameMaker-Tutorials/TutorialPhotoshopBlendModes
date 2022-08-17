// References:
// https://www.deepskycolors.com/archive/2010/04/21/formulas-for-Photoshop-blending-modes.html
// https://github.com/jamieowen/glsl-blend
// https://www.ryanjuckett.com/photoshop-blend-modes-in-hlsl/

varying vec2 v_vTexcoord;

// It's generally a good idea not to do floating point comparisons with ==;
// it's safer to write an equality function/macro function but I'm not getting into that today

uniform sampler2D samp_dst;

uniform int u_BlendMode;

#region Default blending modes
vec3 BlendModeNormal(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeAdd(vec3 src, vec3 dst) {
    return src + dst;
}

vec3 BlendModeSubtract(vec3 src, vec3 dst) {
    return dst - src;
}
#endregion


#region Basic vector math blend modes
vec3 BlendModeDarken(vec3 src, vec3 dst) {
    return min(src, dst);
}

vec3 BlendModeLighten(vec3 src, vec3 dst) {
    return max(src, dst);
}

vec3 BlendModeMultiply(vec3 src, vec3 dst) {
    return src * dst;
}

vec3 BlendModeLinearBurn(vec3 src, vec3 dst) {
    return src + dst - 1.0;
}

vec3 BlendModeScreen(vec3 src, vec3 dst) {
    return 1.0 - ((1.0 - src) * (1.0 - dst));
}

vec3 BlendModeDifference(vec3 src, vec3 dst) {
    return abs(src - dst);
}

vec3 BlendModeExclusion(vec3 src, vec3 dst) {
    return src + dst - 2.0 * src * dst;
}
#endregion


#region Component-wise blend modes
vec3 BlendModeColorBurn(vec3 src, vec3 dst) {
    vec3 tmp;
    tmp.r = (src.r == 0.0) ? src.r : (1.0 - ((1.0 - dst.r) / src.r));
    tmp.g = (src.g == 0.0) ? src.g : (1.0 - ((1.0 - dst.g) / src.g));
    tmp.b = (src.b == 0.0) ? src.b : (1.0 - ((1.0 - dst.b) / src.b));
    
    return tmp;
}

vec3 BlendModeColorDodge(vec3 src, vec3 dst) {
    vec3 tmp;
    tmp.r = (src.r == 1.0) ? src.r : (dst.r / (1.0 - src.r));
    tmp.g = (src.g == 1.0) ? src.g : (dst.g / (1.0 - src.g));
    tmp.b = (src.b == 1.0) ? src.b : (dst.b / (1.0 - src.b));
    
    return tmp;
}

vec3 BlendModeOverlay(vec3 src, vec3 dst) {
    vec3 tmp;
    tmp.r = (dst.r > 0.5) ? (1.0 - (1.0 - 2.0 * (dst.r - 0.5)) * (1.0 - src.r)) : (2.0 * dst.r * src.r);
    tmp.g = (dst.g > 0.5) ? (1.0 - (1.0 - 2.0 * (dst.g - 0.5)) * (1.0 - src.g)) : (2.0 * dst.g * src.g);
    tmp.b = (dst.b > 0.5) ? (1.0 - (1.0 - 2.0 * (dst.b - 0.5)) * (1.0 - src.b)) : (2.0 * dst.b * src.b);
    
    return tmp;
}

vec3 BlendModeSoftLight(vec3 src, vec3 dst) {
    vec3 tmp;
    tmp.r = (src.r > 0.5) ? (1.0 - (1.0 - dst.r) * (1.0 - (src.r - 0.5))) : (dst.r * (src.r + 0.5));
    tmp.g = (src.g > 0.5) ? (1.0 - (1.0 - dst.g) * (1.0 - (src.g - 0.5))) : (dst.g * (src.g + 0.5));
    tmp.b = (src.b > 0.5) ? (1.0 - (1.0 - dst.b) * (1.0 - (src.b - 0.5))) : (dst.b * (src.b + 0.5));
    
    return tmp;
}
#endregion


#region Blend modes that are related to other blend modes
vec3 BlendModeLinearDodge(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeHardLight(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeVividLight(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeLinearLight(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModePinLight(vec3 src, vec3 dst) {
    return src;
}
#endregion


#region Other color operations
vec3 BlendModeHue(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeSaturation(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeLuminosity(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeColor(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeDarkerColor(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeLighterColor(vec3 src, vec3 dst) {
    return src;
}
#endregion


#region I don't have access to a version of Photoshop that can do these
vec3 BlendModeAverage(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeReflect(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeGlow(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeHardMix(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeNegation(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModePhoenix(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeSubstract(vec3 src, vec3 dst) {
    return src;
}
#endregion

void main() {
    vec4 src_color = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 dst_color = texture2D(samp_dst, v_vTexcoord);
    
    vec3 blended_color;
    if (src_color.a < 0.1) {
        blended_color = dst_color.rgb;
    } else {
        
        // Default blend modes
        if (u_BlendMode == 0) {
            blended_color = BlendModeNormal(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 1) {
            blended_color = BlendModeAdd(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 2) {
            blended_color = BlendModeSubtract(src_color.rgb, dst_color.rgb);
        }
        
        
        // Basic vector math blend modes
        if (u_BlendMode == 3) {
            blended_color = BlendModeDarken(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 4) {
            blended_color = BlendModeLighten(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 5) {
            blended_color = BlendModeMultiply(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 6) {
            blended_color = BlendModeLinearBurn(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 7) {
            blended_color = BlendModeScreen(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 8) {
            blended_color = BlendModeDifference(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 9) {
            blended_color = BlendModeExclusion(src_color.rgb, dst_color.rgb);
        }
        
        
        // Component-wise blend modes
        if (u_BlendMode == 10) {
            blended_color = BlendModeColorBurn(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 11) {
            blended_color = BlendModeColorDodge(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 12) {
            blended_color = BlendModeOverlay(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 13) {
            blended_color = BlendModeSoftLight(src_color.rgb, dst_color.rgb);
        }
        
        
        // Blend modes that are related to other blend modes
        if (u_BlendMode == 14) {
            blended_color = BlendModeLinearDodge(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 15) {
            blended_color = BlendModeHardLight(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 16) {
            blended_color = BlendModeVividLight(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 17) {
            blended_color = BlendModeLinearLight(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 18) {
            blended_color = BlendModePinLight(src_color.rgb, dst_color.rgb);
        }
        
        
        // Other color operations
        if (u_BlendMode == 19) {
            blended_color = BlendModeHue(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 20) {
            blended_color = BlendModeSaturation(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 21) {
            blended_color = BlendModeLuminosity(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 22) {
            blended_color = BlendModeColor(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 23) {
            blended_color = BlendModeDarkerColor(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 24) {
            blended_color = BlendModeLighterColor(src_color.rgb, dst_color.rgb);
        }
        
        // I don't have access to a version of Photoshop that can do these
        
        if (u_BlendMode == 25) {
            blended_color = BlendModeAverage(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 26) {
            blended_color = BlendModeReflect(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 27) {
            blended_color = BlendModeGlow(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 28) {
            blended_color = BlendModeHardMix(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 29) {
            blended_color = BlendModeNegation(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 30) {
            blended_color = BlendModePhoenix(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 31) {
            blended_color = BlendModeSubstract(src_color.rgb, dst_color.rgb);
        }
        
    }
    
    // the final blending
    src_color.rgb = blended_color;
    
    //src_color = min(max(src_color, vec4(0.0), vec4(1.0)));
    //dst_color = min(max(dst_color, vec4(0.0), vec4(1.0)));
    src_color = clamp(src_color, vec4(0.0), vec4(1.0));
    dst_color = clamp(dst_color, vec4(0.0), vec4(1.0));
    
    gl_FragColor = src_color * src_color.a + dst_color * (1.0 - src_color.a);
}