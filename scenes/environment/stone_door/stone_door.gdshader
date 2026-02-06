shader_type canvas_item;

/// Progress of the "reveal," from 0.0 (no image) to 1.0 (full image).
uniform float progress : hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment()
{
    // 'UV.y' goes from 0 at the top to 1 at the bottom in Godot's default UV space.
    // We want the reveal to come from the bottom, so we define a threshold:
    float threshold = 1.0 - progress;

    // If the current pixel is below the threshold (meaning it’s in the region
    // that has not yet been revealed), we discard (invisible).
    if (UV.y < threshold) {
        discard;
    }

    // Otherwise, we want to map the portion [threshold .. 1] in UV.y
    // to [0 .. 1] in the texture sample to create a "slide up" effect.
    //
    // Example:
    //   If threshold = 0.8, then the bottom 20% is revealed.
    //   A pixel at UV.y = 0.8 would be mapped to 0.0 in the texture (the very bottom).
    //   A pixel at UV.y = 1.0 would be mapped to 1.0 in the texture (the top).
    //
    // ratio = (UV.y - threshold) / (1.0 - threshold)
    // but (1.0 - threshold) == progress, so:
    float ratio = (UV.y - threshold) / progress;

    // Sample the texture using our adjusted 'ratio' for the y-coordinate.
    // Keep x as is, so the image doesn’t shift left/right.
    vec2 slide_uv = vec2(UV.x, ratio);

    COLOR = texture(TEXTURE, slide_uv);
}