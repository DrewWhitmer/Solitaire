StackClass = {}

require "vector"
require "card"

function StackClass:new(cardTable, xPos, yPos)
  stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.pos = Vector(xPos, yPos)
  stack.cards = cardTable
  stack.offset = CARD_OFFSET
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
  end
  if #self.cards > 0 and self.cards[#self.cards].flipped then
    self.cards[#self.cards].flipped = false
  end
end

function StackClass:draw()
  
end

function StackClass:check(card)
  if #self.cards == 0 and card.num == 13 then
    return true
  end
  
  if #self.cards == 0 then
    return false
  end
  
  local checkingCard = self.cards[#self.cards]
  
  if (card.suit == SUITS.DIAMONDS or card.suit == SUITS.HEARTS) and (checkingCard.suit == SUITS.CLUBS or checkingCard.suit == SUITS.SPADES) and card.num == checkingCard.num - 1 then
    return true
  end
  
  if (card.suit == SUITS.CLUBS or card.suit == SUITS.SPADES) and (checkingCard.suit == SUITS.DIAMONDS or checkingCard.suit == SUITS.HEARTS) and (card.num == checkingCard.num - 1) then
    return true
  end
  
  return false
end

function StackClass:checkForWin()
  return false
end

FinalStackClass = StackClass:new()
function FinalStackClass:new(cardTable, xPos, yPos, suit)
  finStack = {}
  local metadata = {__index = FinalStackClass}
  setmetatable(finStack, metadata)
  
  finStack.pos = Vector(xPos, yPos)
  finStack.cards = cardTable
  finStack.suit = suit
  if suit ~= nil then
    finStack.image = love.graphics.newImage('/assets/' .. finStack.suit .. '.png')
  end
  return finStack
end


function FinalStackClass:update()
  for index, card in ipairs(self.cards) do
    if not card.grabbed then
      card.pos = Vector(self.pos.x, self.pos.y)
    end
    if card.flipped then
      card.grabbable = false
    else
      card.grabbable = true
    end
  end
end

function FinalStackClass:check(card)
  if card == nil then
    return false
  end
  
  if self.suit == card.suit and #self.cards == 0 and card.num == 1 then
    return true
  end
  
  if #self.cards > 12 then
    return false
  end
  
  if #self.cards == 0 then
    return false
  end
  local checkingCard = self.cards[#self.cards]
  
  if self.suit == card.suit and card.num == checkingCard.num + 1 then
    return true
  end
  
  return false
  
end


function FinalStackClass:draw()
  love.graphics.draw(self.image, self.pos.x, self.pos.y)
end

function FinalStackClass:checkForWin()
  if #self.cards == 13 then
    return true
  end
  return false
end

DeckStackClass = StackClass:new()
function DeckStackClass:new(deck, xPos, yPos)
  deckStack = {}
  local metadata = {__index = DeckStackClass}
  setmetatable(deckStack, metadata)
  
  deckStack.pos = Vector(xPos, yPos)
  deckStack.cards = deck
  deckStack.offset = 0
  return deckStack
end

function DeckStackClass:update()
  for index, card in ipairs(self.cards) do
    card.grabbable = false
    card.flipped = true
    card.pos = self.pos
  end
end

function DeckStackClass:check(card)
  return false
end

function DeckStackClass:draw()
  love.graphics.draw(flippedImg, flippedQuad, self.pos.x, self.pos.y, 0, CARD_WIDTH/IMAGE_WIDTH, CARD_HEIGHT/IMAGE_HEIGHT)
end

GrabStackClass = StackClass:new()
function GrabStackClass:new(cardTable, xPos, yPos)
  grabStack = {}
  local metadata = {__index = GrabStackClass}
  setmetatable(grabStack, metadata)
  
  grabStack.pos = Vector(xPos, yPos)
  grabStack.cards = cardTable
  grabStack.offset = CARD_OFFSET
  return grabStack
end

function GrabStackClass:update()
  if #self.cards == 0 then
    return
  end
  
  for index, card in ipairs(self.cards) do
    if not card.grabbed then
      card.pos = Vector(self.pos.x, self.pos.y + (self.offset*index))
    end
    card.grabbable = false
  end
  self.cards[#self.cards].grabbable = true
  
end

function GrabStackClass:check(card)
  return false
end