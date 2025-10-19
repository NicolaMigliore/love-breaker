// extern vec2 screenSize;
const vec2 screenSize = vec2(720, 720);

vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords){

    float x = texture_coords.x;
    float y = texture_coords.y;

    float xUnit = 1.0 / screenSize.x;
    float yUnit = 1.0 / screenSize.y;

    float kernelSize = 5.0;
    vec4 boxBlurColor = vec4(0.0);
    float boxBlurDivisor = pow(2.0 * kernelSize + 1.0, 2.0);

    for(float i = -kernelSize; i <= kernelSize; i++){
        for(float j = -kernelSize; j <= kernelSize; j++){
            vec2 offset = vec2(i * xUnit, j * yUnit);
            vec4 tmpPixel = Texel(image, texture_coords + offset);
            boxBlurColor += tmpPixel;
        }
    }
    boxBlurColor = boxBlurColor / boxBlurDivisor;

    // increase alpha for non black pixels
    if(boxBlurColor.r+boxBlurColor.g+boxBlurColor.b >= 0.2){
        boxBlurColor.a = 1.0;
    }
    
    return boxBlurColor;
}
