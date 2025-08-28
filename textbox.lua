Textbox = Object:extend()

function Textbox:new(headImages, x, y, sounds)
    self.textboximage = love.graphics.newImage("sprites/textBox/textbox.png")
    self.displaylength = 0
    self.x = x
    self.y = y
    self.fullString = "Default text says hi!"
    self.displayString = {}
    self.headImages = headImages
    self.headImages["none"] = nil
    self.display = false
    self.isBuffering = false
    self.sounds = sounds
    self.colors = {
        ["w"] = {1, 1, 1, 1},
        ["r"] = {1, 0, 0, 1},
        ["g"] = {0, 1, 0, 1},
        ["b"] = {0, 0, 1, 1},
        ["y"] = {1, 1, 0, 1},
        ["c"] = {0, 1, 1, 1},
        ["m"] = {1, 0.25, 1, 1},
    }

    self.currentcolor = self.colors["w"]
    self.characterSound = "piano"
end

function Textbox:setSound(string)
    self.characterSound = string
end

function Textbox:setString(string, instantstring)
    self.fullString = string

    if instantstring then
        self:setStringInstant(instantstring)
    else
        self.displayString = {}
        self.displaylength = 0
    end

end

function Textbox:setStringInstant(instantstring)

    self.fullString = instantstring .. self.fullString

end

function Textbox:setHeadImage(string)
    self.headImage = self.headImages[string]
end

function Textbox:increment(dt)
    if self.displaylength/2 < string.len(self.fullString) and self.display then
        self.displaylength = self.displaylength + 1


        if math.fmod(self.displaylength,2) == 0 then
            local incrementString = string.sub(self.fullString, math.floor(self.displaylength/2), math.floor(self.displaylength/2))

                if incrementString == "[" then

                    self.isBuffering = true

                    while self.isBuffering do
                        
                        self.displaylength = self.displaylength + 1

                        incrementString = string.sub(self.fullString, math.floor(self.displaylength/2), math.floor(self.displaylength/2))

                        if incrementString == "]" then
                            
                            self.isBuffering = false
                            
                        else
                            
                            self.currentcolor = self.colors[incrementString]

                        end


                    end


                else

                    table.insert(self.displayString, self.currentcolor)
                    table.insert(self.displayString, incrementString)
                    
                    if

                        self.characterSound
                        and string.sub(self.fullString, (self.displaylength-1)/2, self.displaylength/2) ~= "  "
                        and math.fmod(#self.displayString, 4) == 0

                    then

                        local snd = love.audio.newSource(self.sounds[self.characterSound], "static")
                        snd:play()

                    end
                    
                end

            end

        end

        collectgarbage("collect")
    end

function Textbox:draw()

    if self.display then

        if self.headImage then

            love.graphics.draw(self.textboximage, 70, self.y-50, 0, 0.85, 0.75)
            love.graphics.draw(self.headImage, 90, self.y-32, 0, 1.8, 1.8)
            love.graphics.printf("*", self.x+110, self.y-35, 100, "left", 0, 1.5, 1.5)
            love.graphics.printf(self.displayString, self.x+130, self.y-35, 210, "left", 0, 1.5, 1.50)

        else
            
            love.graphics.draw(self.textboximage, 70, self.y-50, 0, 0.85, 0.75)
            love.graphics.printf("*", self.x+20, self.y-35, 100, "left", 0, 1.5, 1.5)
            love.graphics.printf(self.displayString, self.x+40, self.y-35, 270, "left", 0, 1.5, 1.50)
            
        end

    end

end

function Textbox:setColor(color)
    self.currentcolor = self.colors[color]
end

function Textbox:update(dt)
    self:increment(dt)
end