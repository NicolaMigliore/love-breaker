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
function Utils.mid(n1, n2, n3)
	return math.min(math.max(n1, n2), n3)
end

--- Return number with the provided decimal places
---@param number number number to round down
---@param decimals number number of decimal places to keep
---@return number
function Utils.round(number, decimals)
	decimals = decimals or 0
	local decimalModifier = 10 ^ decimals
	return math.floor(number * decimalModifier) / decimalModifier
end

--- Check if a circle and rectangle are colliding, and return the collision response direction
--- Based on this code: https://www.jeffreythompson.org/collision-detection/circle-rect.php
---@param cx number circle center x coordinate
---@param cy number circle center y coordinate
---@param cr number circle radius
---@param rx number rectangle top-left x coordinate
---@param ry number rectangle top-left y coordinate
---@param rw number rectangle width
---@param rh number rectangle height
---@return boolean hasCollision true if the circle and rectangle are colliding
---@return Vector|nil response a normalized vector pointing away from the closest rectangle side or corner (nil if no collision)
function Utils.collisionCircRect(cx, cy, cr, rx, ry, rw, rh)
	local hasCollision = false
	local response, minDist = nil, math.huge

	-- distances to edges
	local dLeft = math.abs(cx - rx)
	local dRight = math.abs((rx + rw) - cx)
	local dTop = math.abs(cy - ry)
	local dBottom = math.abs((ry + rh) - cy)

	-- check each edge using distances
	if cy >= ry and cy <= ry + rh and dLeft <= cr and dLeft < minDist then
		hasCollision, response, minDist = true, Vector(-1, 0), dLeft
	end
	if cy >= ry and cy <= ry + rh and dRight <= cr and dRight < minDist then
		hasCollision, response, minDist = true, Vector(1, 0), dRight
	end
	if cx >= rx and cx <= rx + rw and dTop <= cr and dTop < minDist then
		hasCollision, response, minDist = true, Vector(0, -1), dTop
	end
	if cx >= rx and cx <= rx + rw and dBottom <= cr and dBottom < minDist then
		hasCollision, response, minDist = true, Vector(0, 1), dBottom
	end

	-- corner case: check distance to rectangle corners
	if not hasCollision then
		-- clamp circle center to rect to find nearest point
		local testX = math.max(rx, math.min(cx, rx + rw))
		local testY = math.max(ry, math.min(cy, ry + rh))
		local dx, dy = cx - testX, cy - testY
		local distSq = dx * dx + dy * dy
		if distSq <= cr * cr then
			hasCollision = true
			local dist = math.sqrt(distSq)
			-- normalize vector from rect corner to circle center
			response = Vector(dx / dist, dy / dist)
		end
	end
	return hasCollision, response
end

--- Check if a two rectangles are colliding
---@param r1x number rectangle 1 x coordinate
---@param r1y number rectangle 1 y coordinate
---@param r1w number rectangle 1 width
---@param r1h number rectangle 1 height
---@param r2x number rectangle 2 x coordinate
---@param r2y number rectangle 2 y coordinate
---@param r2w number rectangle 2 width
---@param r2h number rectangle 2 height
---@return boolean hasCollision true if the rectangles are colliding
function Utils.CollisionRectRect(r1x, r1y, r1w, r1h, r2x, r2y, r2w, r2h)
	local r1BelowR2 = r1y > r2y + r2h
	local r1AboveR2 = r1y + r1h < r2y
	local r1RightOfR2 = r1x > r2x + r2w
	local r1LeftOfR2 = r1x + r1w < r2x
	if r1BelowR2 or r1AboveR2 or r1RightOfR2 or r1LeftOfR2 then
		return false
	end
	return true
end

function Utils.printLabel(msg, x, y, align)
	align = align or ALIGNMENTS.left
	local font = love.graphics.getFont()
	local text = love.graphics.newText(font, msg)
	local tw, th = text:getWidth(), text:getHeight()
	if tw % 2 == 0 then tw = tw + 1 end
	y = y - th / 2

	if align == ALIGNMENTS.center then x = x - tw / 2 end
	if align == ALIGNMENTS.right then x = x - tw end

	x, y = math.floor(x), math.floor(y)
	love.graphics.draw(text, x, y)
end

function Utils.drawDashedLine(x1, y1, x2, y2, dashLength, gapLength)
	dashLength = dashLength or 10
	gapLength = gapLength or 5
	local dx = x2 - x1
	local dy = y2 - y1
	local totalLength = math.sqrt(dx * dx + dy * dy)

	local numDashes = math.floor(totalLength / (dashLength + gapLength))

	-- Normalize direction vector
	local dirX = dx / totalLength
	local dirY = dy / totalLength

	for i = 0, numDashes do
		local startX = x1 + dirX * (i * (dashLength + gapLength))
		local startY = y1 + dirY * (i * (dashLength + gapLength))
		local endX = startX + dirX * dashLength
		local endY = startY + dirY * dashLength

		love.graphics.line(startX, startY, endX, endY)
	end
end

-- Convert hex to RGB (0-1 range)
function Utils.hexToRGB(hex)
	return {
		tonumber(hex:sub(1, 2), 16) / 255,
		tonumber(hex:sub(3, 4), 16) / 255,
		tonumber(hex:sub(5, 6), 16) / 255,
		1 -- Alpha is always 1 here
	}
end

return Utils
