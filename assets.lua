--[[
An Asset() is an Object with a name, an array of animations, an x and y position, a set of offsets 
for its animations and a boolean determining whether it is currently drawn.

The animatios are passed as such:

animationArray = {
    [1] = {"animationName", animationLength, animationFramerate}
}

Upon creation, the Asset object turns this array into ImageData it can use by scouring in

    sprites/animationName/1.png, sprites/animationName/2.png

and so on.

The frames MUST be named 1 through the number of frames and have a .png extension. For example animations, check the "sprites/" folder

Asset:setAnimation(number) sets the Object's animation to the given number. This function only accepts the number the animation
is indexed in, not the name of the animation.

Asset:setFrame(number) sets the animation's current frame to the set number.
This will pause the animation, and you must manually reactivate it with Asset.isactive = true later on.

]]

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