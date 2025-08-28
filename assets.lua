Asset = Object:extend()

function Asset:new(name, frames, x, y, offsets)

    self.x = x
    self.y = y

    self.name = name
    self.animations = {}
    self.fps = {}
    self.maxframecounts = {}
    self.frames = {}
    
    for i = 1, #frames do
        self.frames[i] = {}
        for j = 1, frames[i][2] do
            self.frames[i][j] = love.graphics.newImage("sprites/"..frames[i][1].."/"..j..".png")
            --print("sprites/"..frames[i][1].."/"..j..".png")
        end
        self.maxframecounts[i] = frames[i][2]
        self.fps[i] = frames[i][3]
    end

    self.offsets = offsets

    self.currentanimation = 1
    self.currentframecount = 1

    self.isactive = true

end

function Asset:draw()
    love.graphics.draw(self.currentframe, self.x+self.offsets[self.currentanimation][1], self.y+self.offsets[self.currentanimation][2], 0, 2, 2)
end

function Asset:update(dt)
    self:animate(dt)
end

function Asset:animate(dt)
    if self.isactive then
        self.currentframecount = self.currentframecount + dt*self.fps[self.currentanimation]

        local fcheck = math.floor(self.currentframecount)
        if fcheck > self.maxframecounts[self.currentanimation] then
            self.currentframecount = 1
        end
        self.currentframe = self.frames[self.currentanimation][math.floor(self.currentframecount)]
    end
end

function Asset:setAnimation(num)
    self.currentanimation = num
    self.currentframe = self.frames[num][1]
end

function Asset:setFrame(num)
    self.isactive = false
    self.currentframecount = num
    self.currentframe = self.frames[self.currentanimation][num]
end