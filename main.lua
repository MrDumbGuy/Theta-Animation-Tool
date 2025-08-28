flux = require "flux"
tick = require "tick"
Object = require "classic"
require "assets"
require "textbox"

love.graphics.setDefaultFilter("nearest")

local FONT = love.graphics.newFont("fonts/font.ttf")
love.graphics.setFont(FONT)

local SONG = love.audio.newSource("songs/castletown.ogg", "stream")

local Susie
local Ralsei
local Texty
local Fountain

local backgroundImage = love.graphics.newImage("sprites/bg.png")

local prophecy = {
    image = love.graphics.newImage("sprites/prophecy.png"),
    isshown = false
}

local letter = {
    image = love.graphics.newImage("sprites/letter.png"),
    isshown = false,
    x = 308,
    y = 0,
}

local eventno = 0

function love.load()

    love.window.setMode(640, 480)

    local susieAnims = {
        [1] = {"susieWalkUp", 4, 4},
        [2] = {"susieWalkDown", 4, 4},
        [3] = {"susieWalkLeft", 4, 4},
        [4] = {"susieWalkRight", 4, 4},
        [5] = {"susieDisinterested", 1, 1},
        [6] = {"susieShocked", 1, 1},
        [7] = {"susieHoldPaper", 1, 1},
    }

    local susieOffsets = {
        [1] = {0, -2},
        [2] = {0, 0},
        [3] = {0, 0},
        [4] = {0, 0},
        [5] = {-14, -2},
        [6] = {-20, 0},
        [7] = {0, 0},
    }

    local ralseiAnims = {
        [1] = {"ralseiWalkUp", 4, 4},
        [2] = {"ralseiWalkDown", 4, 4},
        [3] = {"ralseiWalkLeft", 4, 4},
        [4] = {"ralseiWalkRight", 4, 4},
        [5] = {"ralseiShocked", 1, 1},
        [6] = {"ralseiWait", 1, 1},
        [7] = {"ralseiWait2", 1, 1},
    }

    local ralseiOffsets = {
        [1] = {0, 0},
        [2] = {0, 0},
        [3] = {0, 0},
        [4] = {0, 0},
        [5] = {-10, 0},
        [6] = {0, 0},
        [7] = {0, 0}
    }

    local fountainAnims = {

        [1] = {"bgFountain", 3, 3}
    }

    local fountainOffsets = {
        [1] = {0, 0}
    }

    local headImages = {
        ["susieDefault"] = love.graphics.newImage("sprites/textBox/susieDefault.png"),
        ["susieRead"] = love.graphics.newImage("sprites/textBox/susieRead.png"),
        ["susieShocked"] = love.graphics.newImage("sprites/textBox/susieShocked.png"),
        ["susieWTF"] = love.graphics.newImage("sprites/textBox/susieWTF.png"),
        ["susieLame"] = love.graphics.newImage("sprites/textBox/susieLame.png"),
        ["ralseiDefault"] = love.graphics.newImage("sprites/textBox/ralseiDefault.png"),
        ["ralseiSecretive"] = love.graphics.newImage("sprites/textBox/ralseiSecretive.png"),
        ["ralseiUnsure"] = love.graphics.newImage("sprites/textBox/ralseiUnsure.png"),
        ["ralseiNerd"] = love.graphics.newImage("sprites/textBox/ralseiNerd.png"),
    }

    local snds = {
        ["susie"] = "sounds/snd_txtsus.wav",
        ["ralsei"] = "sounds/snd_txtral.wav",
        ["piano"] = "sounds/snd_text.wav",
    }

    Susie = Asset("Susie", susieAnims, 160, 200, susieOffsets)
    Ralsei = Asset("Ralsei", ralseiAnims, 440, 248, ralseiOffsets)
    Fountain = Asset("Fountain", fountainAnims, 296, 0, fountainOffsets)

    Fountain:setAnimation(1)

    Susie:setAnimation(2)
    Susie.currentframecount = 1
    Susie.isactive = false

    Ralsei:setAnimation(3)
    Ralsei.currentframecount = 1
    Ralsei.isactive = false

    Texty = Textbox(headImages, 70, 400, snds)
    Texty:setHeadImage("susieDefault")

end

function love.keypressed(key)
    
    if key == "z" then
        CruelAngel()
    end

end

function love.draw()
    love.graphics.draw(backgroundImage, 0, 0)

    Susie:draw()
    Ralsei:draw()
    Texty:draw()

    Fountain:draw()

    if letter.isshown then
        love.graphics.draw(letter.image, letter.x, letter.y, 0, 2, 2)
    end

    if prophecy.isshown then
        love.graphics.draw(prophecy.image, 0, 0, 0, 4, 4)
    end

    local fps = love.timer.getFPS()
    if fps then
        love.graphics.printf("FPS: "..fps, 0, 0, 100, "left")
    end

end

function love.update(dt)
    flux.update(dt)
    Susie:update(dt)
    Ralsei:update(dt)
    Fountain:update(dt)
    Texty:update(dt)
    tick.update(dt)
end

function CruelAngel()

    eventno = eventno + 1

    if eventno == 1 then
        SONG:play()
        flux.to(Susie, 2, {y = 240}):ease("linear"):oncomplete(CruelAngel)
        Susie.isactive = true
    elseif eventno == 2 then
        Susie:setAnimation(4)
        Susie:setFrame(3)
        CruelAngel()
    elseif eventno == 3 then
        Texty.display = true
        Texty:setSound("susie")
        Texty:setHeadImage("susieDefault")
        Texty:setString("Hey [g]Ralsei[w], what do you know about the [c]Angel[w]?")
        tick.delay(function () CruelAngel() end, 3)
    elseif eventno == 4 then
        Texty:setSound("ralsei")
        Texty:setHeadImage("ralseiUnsure")
        Texty:setString("I don't know much, [m]Susie.[w]")
        Ralsei.isactive = true
        flux.to(Ralsei, 2, {x = 320}):ease("linear"):oncomplete(CruelAngel)
    elseif eventno == 5 then
        Ralsei:setFrame(1)
        Texty:setString("\n[c]The Prophecy[w] mentions that", "I don't know much, [m]Susie.[w]")
        tick.delay(function () CruelAngel() end, 2)
    elseif eventno == 6 then
        prophecy.isshown = true
        tick.delay(function () CruelAngel() end, 3)
    elseif eventno == 7 then
        prophecy.isshown = false
        Susie:setAnimation(5)
        Texty:setSound("susie")
        Texty:setHeadImage("susieLame")
        Texty:setString("So, it's a [y]student[w] then?                              That's lame.")
        tick.delay(function () CruelAngel() end, 3)
    elseif eventno == 8 then
        Susie.isactive = false
        Susie.currentframecount = 1
        Texty:setSound("ralsei")
        Texty:setHeadImage("ralseiNerd")
        Texty:setString("Well it's [r]hard to say[w].                                    We don't know what heaven's like, and [b]books[w] may be an [y]allegory[w].")
        tick.delay(function () CruelAngel() end, 5)
    elseif eventno == 9 then
        Texty:setString("")
        letter.isshown = true
        Texty:setSound("susie")
        Texty:setHeadImage("susieShocked")
        Texty:setString("Is that coming down from [r]HEAVEN?[w]")
        tick.delay(function () CruelAngel() end, 3)
        flux.to(letter, 5, {x = Susie.x-20, y = Susie.y}):ease("circin"):oncomplete(CruelAngel)
        Susie:setAnimation(6)
        Ralsei:setAnimation(5)
    elseif eventno == 10 then
        Texty:setSound("ralsei")
        Ralsei:setAnimation(6)
        Texty:setHeadImage("ralseiSecretive")
        Texty:setString("[m]Susie[r] wait![w]")
    elseif eventno == 11 then
        letter.isshown = false
        Susie:setAnimation(7)
        Ralsei:setAnimation(7)
        Texty:setSound("susie")
        Texty:setHeadImage("susieRead")
        Texty:setString("\"In conclusion, we can say [r]manipulative acts[w] are a necessity for society. Evil rules!\"")
        tick.delay(function () CruelAngel() end, 3)
    elseif eventno == 12 then
        Texty:setString("\"The Angel - July 11th 202X\"")
        tick.delay(function () CruelAngel() end, 2)
    elseif eventno == 13 then
        letter.isshown = false
        Susie:setAnimation(7)
        Texty:setHeadImage("susieWTF")
        Texty:setString("What the hell?! What kind of [r]Cruel Angel's Thesis[w] is this?!")
        tick.delay(function () CruelAngel() end, 3)
    elseif eventno == 14 then
        Texty:setHeadImage("none")
        Texty:setSound("piano")
        Texty:setString("It was like in they were some king of")
        tick.delay(function () Texty:setString("\n[r]Neon Genesis Evangelion:[w]", "It was like in they were some king of") end, 3)
    end
end