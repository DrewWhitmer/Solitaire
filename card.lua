
CardClass = {}

require "vector"


CARD_WIDTH = 70
CARD_HEIGHT = 95

IMAGE_WIDTH = 140
IMAGE_HEIGHT = 190

flippedImg = love.graphics.newImage('/assets/playingCardBacks.png')
flippedQuad = love.graphics.newQuad(0, 380, IMAGE_WIDTH, IMAGE_HEIGHT, flippedImg) 


function CardClass:new(s, n, f, g, grabbed, xPos, yPos)
  local card = {}
  local metatable = {__index = CardClass}
  setmetatable(card, metatable)
  card.suit = s
  card.num = n
  card.flipped = f
  card.grabbable = g
  card.grabbed = grabbed
  card.pos = Vector(xPos, yPos)
  card.size = Vector(CARD_WIDTH, CARD_HEIGHT)
  
  return card
  
end

function CardClass:update()
  
end

function CardClass:draw()
  if self.flipped then
    love.graphics.draw(flippedImg, flippedQuad, self.pos.x, self.pos.y, 0, self.size.x/IMAGE_WIDTH, self.size.y/IMAGE_HEIGHT)
  else
    iffy.drawSprite("card" .. self.suit .. self.num .. '.png', self.pos.x, self.pos.y, 0, self.size.x/IMAGE_WIDTH, self.size.y/IMAGE_HEIGHT)
  end
  
end