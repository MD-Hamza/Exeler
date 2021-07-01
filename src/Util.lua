function tileQuads(width, height, atlas, startX, startY, jumpX, jumpY)
    startX = startX or 0
    startY = startY or 0
    jumpX = jumpX or 0
    jumpY = jumpY or 0

	local cols = math.floor((atlas:getWidth() + jumpX) / (width + jumpX))
	local rows = math.floor((atlas:getHeight() + jumpY) / (height + jumpY))
	local quads = {}

	for y = 0, rows - 1 do
		for x = 0, cols - 1 do
            local posX = startX + x * (width + jumpX)
            local posY = startY + y * (height + jumpY)

			local quad = love.graphics.newQuad(posX, posY, width, height, atlas:getDimensions())
			table.insert(quads, quad)
		end
	end
	return quads
end

function table.slice(tbl, slices)
	sliced = {}
    
    for k, slice in pairs(slices) do
        for i = slice[1] or 1, slice[2] or #tbl, slice[3] or 1 do
            sliced[#sliced+1] = tbl[i]
        end
    end

	return sliced
end

function drawAnimation(animation, x, y)
    love.graphics.draw(gTextures[animation.texture]["character"], 
        gFrames[animation.texture]["character"][animation:getCurrentFrame()], x, y)
    love.graphics.draw(gTextures[animation.texture]["robe"],
        gFrames[animation.texture]["robe"][animation:getCurrentFrame()], x, y)
    love.graphics.draw(gTextures[animation.texture]["torso"], 
        gFrames[animation.texture]["torso"][animation:getCurrentFrame()], x, y)
    love.graphics.draw(gTextures[animation.texture]["belt"],
        gFrames[animation.texture]["belt"][animation:getCurrentFrame()], x, y)
    love.graphics.draw(gTextures[animation.texture]["head"],
        gFrames[animation.texture]["head"][animation:getCurrentFrame()], x, y)
end

function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end