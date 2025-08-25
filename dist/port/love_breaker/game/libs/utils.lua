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

--- Returns the middle of 3 numbers
---@param n1 number one of the numbers to check
---@param n2 number one of the numbers to check
---@param n3 number one of the numbers to check
function Utils.mid(n1,n2,n3)
    return math.min(math.max(n1,n2), n3)
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
---@return number hasCollision where the circle and rectangle are colliding
---@return boolean rectLect if the collision happened over the rectangle's left edge
---@return boolean rectRight if the collision happened over the rectangle's right edge
---@return boolean rectTop if the collision happened over the rectangle's top edge
---@return boolean rectBottom if the collision happened over the rectangle's bottom edge
function Utils.collisionCircRect(cx,cy,cr,rx,ry,rw,rh)
    -- set test edges
    local testX, testY = cx, cy

    -- set x collision-point coordinate
    if cx < rx then
        testX = rx
    elseif cx > rx+rw then
        testX = rx+rw
    end

    -- set y collision-point coordinate
    if cy < ry then
        testY = ry
    elseif cy > ry+rh then
        testY = ry+rh
    end

    -- point distance between circle center and test edge
    local distX = cx-testX
    local distY = cy-testY
    local dist = math.sqrt(distX^2 + distY^2)

    -- get collision edges of rectangle
    local rectLeft = cx < rx and (cy+cr >= ry and cy-cr <= ry+rh)
    local rectRight = cx > rx+rw and (cy+cr >= ry and cy-cr <= ry+rh)
    local rectTop = cy < ry and (cx+cr >= rx and cx-cr <= rx+rw)
    local rectBottom = cy > ry+rh and (cx+cr >= rx and cx-cr <= rx+rw)

    -- compare distance with radius
    return dist <= cr, rectLeft, rectRight, rectTop, rectBottom
end

function Utils.printLabel(msg,x,y,align)
    align = align or ALIGNMENTS.left
    local font = love.graphics.getFont()
    local text = love.graphics.newText(font,msg)
    local tw,th = text:getWidth(), text:getHeight()
    if tw%2==0 then tw = tw + 1 end
    y = y - th/2

    if align == ALIGNMENTS.center then x = x -tw/2 end
    if align == ALIGNMENTS.right then x = x -tw end

    x,y = math.floor(x), math.floor(y)
    love.graphics.draw(text,x,y)
end

return Utils