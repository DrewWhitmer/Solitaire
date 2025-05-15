require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(love.mouse.getX(), love.mouse.getY())
end

function GrabberClass:grab(stackTable)
  self.grabPos = self.currentMousePos
  local grabbedCards = {}
  
  for _, stack in ipairs(stackTable) do
    if self.grabPos.x >= stack.pos.x and self.grabPos.x <= stack.pos.x + CARD_WIDTH then
      local lowestIndex = #stack.cards + 1
      -- find the lowest card that the player is grabbing
      for index, card in ipairs(stack.cards) do
        if self.grabPos.y >= stack.pos.y + (index*CARD_OFFSET) and self.grabPos.y <= stack.pos.y + CARD_HEIGHT + (index*stack.offset) and card.grabbable and stack.pos.y ~= 50 then
          lowestIndex = index
        end
      end
      -- add all cards below the card the player is grabbing to grabbedCards table
      for index, card in ipairs(stack.cards) do
        if index >= lowestIndex then
          card.grabbed = true
          table.insert(grabbedCards, card)
        end
      end
    end
  end
  return grabbedCards
end

function GrabberClass:release(stackTable, grabbedCards)
  self.grabPos = nil
  
  if grabbedCards == nil or #grabbedCards == 0 then
    return
  end
  
  -- set grabbed cards to not be grabbed anymore
  for _, card in ipairs(grabbedCards) do
    card.grabbed = false
  end
  
  for _, stack in ipairs(stackTable, grabbedCards) do
    if self.currentMousePos.x >= stack.pos.x and self.currentMousePos.x <= stack.pos.x + CARD_WIDTH and self.currentMousePos.y >= stack.pos.y and self.currentMousePos.y <= stack.pos.y + ((#stack.cards)*stack.offset + CARD_HEIGHT) and stack:check(grabbedCards[1]) then
      for index, card in ipairs(grabbedCards) do
        table.insert(stack.cards, card:remove(stackTable))
      end
    end
  end
  
  return {}
end