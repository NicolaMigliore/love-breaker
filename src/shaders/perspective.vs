uniform float tilt;
uniform vec2 screenSize;

vec4 position( mat4 transform_projection, vec4 vertex_position ){
    // Shift origin to center of canvas
    float centeredX = vertex_position.x - screenSize.x / 2.0;
    float centeredY = vertex_position.y - screenSize.y / 2.0;

    // Apply vertical skew (tilt)
    centeredY += centeredX * tilt;

    // Apply vertical scale to simulate depth
    float scaleY = 1.0 - abs(centeredX / screenSize.x) * abs(tilt) * 0.5;
    centeredY *= scaleY;

    // Shift back to original coordinate space
    vec2 finalPos = vec2(centeredX + screenSize.x / 2.0, centeredY + screenSize.y / 2.0);

    return transform_projection * vec4(finalPos, 0.0, 1.0);
}