StackClass = {}

require "vector"
require "card"

function StackClass:new(cardTable, xPos, yPos)
  stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.pos = Vector(xPos, yPos)
  stack.cards = cardTable
  for index, card in ipairs(stack.cards) do
    card.pos = Vector(stack.pos.x, stack.pos.y + (10*index))
  end
  return stack
end

function StackClass:refresh()
  for index, card in ipairs(self.cards) do
    card.pos = Vector(self.pos.x, self.pos.y + (10*index))
  end
end
  