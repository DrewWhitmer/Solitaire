
CardClass = {}

require "vector"

CARD_WIDTH = 70
CARD_HEIGHT = 95

IMAGE_WIDTH = 140
IMAGE_HEIGHT = 190

flippedImg = love.graphics.newImage('/assets/playingCardBacks.png')
flippedQuad = love.graphics.newQuad(0,380,IMAGE_WIDTH,IMAGE_HEIGHT,flippedImg) 

faceImg = love.graphics.newImage('/assets/playingCards.png')


function CardClass:new(s,n,f,g,grabbed,xPos,yPos)
  local card = {}
  local metatable = {__index = CardClass}
  setmetatable(card, metatable)
  card.suit = s
  card.num = n
  card.flipped = f
  card.grabbable = g
  card.grabbed = grabbed
  card.pos = Vector(xPos,yPos)
  card.size = Vector(CARD_WIDTH,CARD_HEIGHT)
  
  --load the card specific quad (there is almost certainly a way to actually read the xml file but i dont feel like it)
  if card.suit == 'spades' then
    if 11 > card.num and card.num > 4 then
      card.quad = love.graphics.newQuad(0, 1710 - (card.num - 5)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num < 5 then
      card.quad = love.graphics.newQuad(140, 380 - (card.num -2)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 1 then
      card.quad = love.graphics.newQuad(0, 570, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 11 then
      card.quad = love.graphics.newQuad(0, 380, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 12 then
      card.quad = love.graphics.newQuad(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    else
      card.quad = love.graphics.newQuad(0, 190, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    end
  elseif card.suit == 'hearts' then
    if 2 < card.num and card.num < 9 then
      card.quad = love.graphics.newQuad(280, 950 - (card.num - 3)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif 11 > card.num and card.num > 8 then
      card.quad = love.graphics.newQuad(140, 1710 - (card.num - 9)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 1 then
      card.quad = love.graphics.newQuad(140, 1330, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 11 then
      card.quad = love.graphics.newQuad(140, 1140, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 13 then
      card.quad = love.graphics.newQuad(140, 950, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    else
      card.quad = love.graphics.newQuad(140, 760, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    end
  elseif card.suit == 'diamonds' then
    if 11 > card.num and card.num > 1 then
      card.quad = love.graphics.newQuad(420, 1710 - (card.num - 2)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 1 then
      card.quad = love.graphics.newQuad(420, 0, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 11 then
      card.quad = love.graphics.newQuad(280, 1710, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    elseif card.num == 12 then
      card.quad = love.graphics.newQuad(280, 1330, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    else
      card.quad = love.graphics.newQuad(280, 1520, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
    end
    --card has to be clubs
  elseif 11 > card.num and card.num > 4 then
    card.quad = love.graphics.newQuad(560, 1710 - (card.num - 5)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  elseif 5 > card.num and card.num > 2 then
    card.quad = love.graphics.newQuad(700, 190 - (card.num - 3)*IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  elseif card.num == 2 then
    card.quad = love.graphics.newQuad(280, 1140, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  elseif card.num == 1 then
    card.quad = love.graphics.newQuad(560, 570, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  elseif card.num == 11 then
    card.quad = love.graphics.newQuad(560, 380, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  elseif card.num == 12 then
    card.quad = love.graphics.newQuad(560, 0, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  else
    card.quad = love.graphics.newQuad(560, 190, IMAGE_WIDTH, IMAGE_HEIGHT, faceImg)
  end
  
  return card
  
end

function CardClass:update()
  
end

function CardClass:draw()
  if self.flipped then
    love.graphics.draw(flippedImg, flippedQuad, self.pos.x, self.pos.y, 0, self.size.x/IMAGE_WIDTH, self.size.y/IMAGE_HEIGHT)
  else
    love.graphics.draw(faceImg, self.quad, self.pos.x, self.pos.y, 0, self.size.x/IMAGE_WIDTH, self.size.y/IMAGE_HEIGHT)
  end
  
end