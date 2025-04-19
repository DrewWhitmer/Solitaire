-- Drew Whitmer
-- CMPM 121 - Solitaire
-- 4/8/2025
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable1 = {}
  
  --put all cards in one table
  for i = 1, 13 do
    table.insert(cardTable1, CardClass:new('clubs',i,true,true,false,0,0))
  end
  for i = 1, 13 do
    table.insert(cardTable1, CardClass:new('hearts',i,true,true,false,0,0))
  end
  for i = 1, 13 do
    table.insert(cardTable1, CardClass:new('spades',i,true,true,false,0,0))
  end
  for i = 1, 13 do
    table.insert(cardTable1, CardClass:new('diamonds',i,true,true,false,0,0))
  end
  
  stackTable = {}
  
  table.insert(stackTable, StackClass:new({}, 100, 100, 10))
  table.insert(stackTable, StackClass:new({}, 200, 100, 10))
  table.insert(stackTable, StackClass:new({}, 300, 100, 10))
  table.insert(stackTable, StackClass:new({}, 400, 100, 10))
  table.insert(stackTable, StackClass:new({}, 500, 100, 10))
  table.insert(stackTable, StackClass:new({}, 600, 100, 10))
  table.insert(stackTable, StackClass:new({}, 700, 100, 10))
  
  for i = 1, 7 do
    for j = 1, i do
      local num = math.random(#cardTable1)
      local card = cardTable1[num]
      table.remove(cardTable1, num)
      table.insert(stackTable[i].cards, card)
    end
    stackTable[i]:update()
  end
  
  
end

function love.update()
  
  grabber:update()
  
  for _, stack in ipairs(stackTable) do
    for index, card in ipairs(stack.cards) do
      --checks if grab is happening and if the grab position is on the card
      if grabber.grabPos ~= nil and grabber.grabPos.x >= card.pos.x and grabber.grabPos.x <= card.pos.x + CARD_WIDTH and grabber.grabPos.y >= card.pos.y and grabber.grabPos.y <= card.pos.y + CARD_HEIGHT and card.grabbable == true and card.grabbed ~= true then 
        -- sets current card to grabbed
        card.grabbed = true 
        -- sets above cards to not grabbed, sets below cards to be grabbed
        for newIndex, newCard in ipairs(stack.cards) do
          if newIndex < index then
            newCard.grabbed = false
          elseif newIndex > index then
            newCard.grabbed = true
          end
        end
      end
  
      if card.grabbed == true and grabber.grabPos == nil then
        --lets go of the card when the player releases
        card.grabbed = false
        for _, newStack in ipairs(stackTable) do 
          if grabber.currentMousePos.x >= newStack.pos.x and grabber.currentMousePos.x <= newStack.pos.x + CARD_WIDTH and grabber.currentMousePos.y >= newStack.pos.y and grabber.currentMousePos.y <= newStack.pos.y + ((#newStack.cards)*newStack.offset + CARD_HEIGHT) then
            table.remove(stack.cards, index)
            table.insert(newStack.cards, card)
          end
        end
      end
      card:update()
    end
    stack:update()
  end

end

function love.draw()
  for _, stack in ipairs(stackTable) do
    for _, card in ipairs(stack.cards) do
      card:draw()
    end
  end
end
