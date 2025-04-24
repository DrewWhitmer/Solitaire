StackClass = {}

require "vector"
require "card"

function StackClass:new(cardTable, xPos, yPos, off, finStack, suit)
  stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.pos = Vector(xPos, yPos)
  stack.cards = cardTable
  stack.offset = off
  stack.final = finStack
  stack.suit = suit
  if suit ~= nil then
    stack.image = love.graphics.newImage('/assets/' .. stack.suit .. '.png')
    print(stack.image)
  end
  for index, card in ipairs(stack.cards) do
    card.pos = Vector(stack.pos.x, stack.pos.y + (stack.offset*index))
  end
  return stack
end

function StackClass:update()
  for index, card in ipairs(self.cards) do
    if not card.grabbed then
      card.pos = Vector(self.pos.x, self.pos.y + (self.offset*index))
    end
    
    if card.flipped then
      card.grabbable = false
    else
      card.grabbable = true
    end
    
    if self.final then
      card.grabbable = false
      card.flipped = false
    end
  end
  if #self.cards > 0 and self.cards[#self.cards].flipped then
    self.cards[#self.cards].flipped = false
  end
end

function StackClass:draw()
  if self.final then
    love.graphics.draw(self.image, self.pos.x, self.pos.y)
    return
  else
    return
  end
end

