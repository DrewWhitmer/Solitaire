
CardClass = {}

require "vector"


CARD_WIDTH = 70
CARD_HEIGHT = 95

IMAGE_WIDTH = 140
IMAGE_HEIGHT = 190

flippedImg = love.graphics.newImage('/assets/playingCardBacks.png')
flippedQuad = love.graphics.newQuad(0, 380, IMAGE_WIDTH, IMAGE_HEIGHT, flippedImg) 


function CardClass:new(suit, num, flipped, grabbable, grabbed, xPos, yPos)
  local card = {}
  local metatable = {__index = CardClass}
  setmetatable(card, metatable)
  card.suit = suit
  card.num = num
  card.flipped = flipped
  card.grabbable = grabbable
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

function CardClass:remove(stackTable)
  for _, stack in ipairs(stackTable) do
    for index, card in ipairs(stack.cards) do
      if self.num == card.num and self.suit == card.suit then
        table.remove(stack.cards, index)
        return self
      end
    end
  end
end
