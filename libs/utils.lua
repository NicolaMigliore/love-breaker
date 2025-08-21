local Utils = {}

--- Return the sign of the provided number.
--- - returns 1 if number is positive
--- - returns -1 if number is positive
--- - returns 0 if the number is 0
---@param number number the number to check
---@return integer
function Utils.sign(number)
    return (number > 0 and 1) or (number == 0 and 0) or -1
end

--- Return number with the provided decimal places
---@param number number number to round down
---@param decimals number number of decimal places to keep
---@return number
function Utils.round(number, decimals)
    decimals = decimals or 0
    local decimalModifier = 10^decimals
    return math.floor(number*decimalModifier)/decimalModifier
end

--- Check if circle and rectangle are colliding
--- Based on this code: https://www.jeffreythompson.org/collision-detection/circle-rect.php 
---@param cx number circle center x coordinate
---@param cy number circle center y coordinate
---@param cr number circle radius
---@param rx number rectangle top-left x coordinate
---@param ry number rectangle top-left y coordinate
---@param rw number rectangle width
---@param rh number rectangle height
function Utils.collisionCircRect(cx,cy,cr,rx,ry,rw,rh)
    -- set test edges
    local testX, testY = cx, cy

    if cx < rx then
        testX = rx
    elseif cx > rx+rw then
        testX = rx+rw
    end

    if cy < ry then
        testY = ry
    elseif cy > ry+rh then
        testY = ry+rh
    end

    -- point distance between circle center and test edge
    local distX = cx-testX
    local distY = cy-testY
    local dist = math.sqrt(distX^2 + distY^2)

    -- compare distance with radius
    return dist <= cr
end

return Utils