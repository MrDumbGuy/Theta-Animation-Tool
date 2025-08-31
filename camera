--The Camera object is a simple Object allowing for the movement of every object except for the one it's focused on.
--So basically it handles 100s of flux commands so you don't.
--This currently does not have the functionality to dynamically track the position of the focused character in order to move everything else.
--And that's not a feature I plan on implementing.

Camera = Object:extend()

function Camera:new()
    self.focus = nil
end

function Camera:setFocus(Asset)
    --You can set this to nil if you want to move everything.
    self.focus = Asset
end

function Camera:move(x, y, t)

    flux.to(BackgroundPos, t, {x = BackgroundPos.x + x, y = BackgroundPos.y + y}):ease("linear")
    for i = 1, #Drawables do
        print(Drawables[i])
        if Drawables[i] ~= self.focus then
            flux.to(Drawables[i], t, {x = Drawables[i].x + x, y = Drawables[i].y + y}):ease("linear")
        end
    end
end