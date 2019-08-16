--
-- Created by IntelliJ IDEA.
-- User: Rafael
-- Date: 05/11/2018
-- Time: 21:32
-- To change this template use File | Settings | File Templates.
--

cartographer = require 'libs.cartographer'
baton = require 'libs.baton'
anim8 = require 'libs.anim8'
Class = require "hump.class"
Gamestate = require "hump.gamestate"
vector = require "hump.vector-light"

Camera = require "hump.camera"
Timer = require "hump.timer"

local game = require "states.game"



function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    love.window.setTitle("Brickmania")
    Gamestate.registerEvents()
    Gamestate.switch(game,"game")
end