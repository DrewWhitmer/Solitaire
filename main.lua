-- Drew Whitmer
-- CMPM 121 - Solitaire
-- 4/8/2025
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "stack"

CARD_OFFSET = 20

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  deck = {}
  
  --put all cards in one table
  for i = 1, 13 do
    table.insert(deck, CardClass:new('clubs',i,true,true,false,0,0))
  end
  for i = 1, 13 do
    table.insert(deck, CardClass:new('hearts',i,true,true,false,0,0))
  end
  for i = 1, 13 do
    table.insert(deck, CardClass:new('spades',i,true,true,false,0,0))
  end
  for i = 1, 13 do
    table.insert(deck, CardClass:new('diamonds',i,true,true,false,0,0))
  end
  
  stackTable = {}
  
  table.insert(stackTable, StackClass:new({}, 200, 100, CARD_OFFSET))
  table.insert(stackTable, StackClass:new({}, 300, 100, CARD_OFFSET))
  table.insert(stackTable, StackClass:new({}, 400, 100, CARD_OFFSET))
  table.insert(stackTable, StackClass:new({}, 500, 100, CARD_OFFSET))
  table.insert(stackTable, StackClass:new({}, 600, 100, CARD_OFFSET))
  table.insert(stackTable, StackClass:new({}, 700, 100, CARD_OFFSET))
  table.insert(stackTable, StackClass:new({}, 800, 100, CARD_OFFSET))
  
  
  --Modern Fisher-Yates
  local cardCount = #deck
  for i = 1, cardCount do
    local randIndex = math.random(cardCount)
    local temp = deck[randIndex]
    deck[randIndex] = deck[cardCount]
    deck[cardCount] = temp
    cardCount = cardCount - 1
  end
  
  grabStack = StackClass:new(deck,50,50,0)
  newCardStack = StackClass:new({},50,120,0)
  tempStack = {}
  
  for i = 1, 7 do
    for j = 1, i do
      local card = deck[1]
      table.remove(deck, 1)
      table.insert(stackTable[i].cards, card)
    end
    stackTable[i]:update()
  end
  
  check = false
  
  
end

function love.update()
  
  grabber:update()
  grabbedCards = 0
  for _, stack in ipairs(stackTable) do
    for index, card in ipairs(stack.cards) do
      --checks if grab is happening and if the grab position is on the card
      if grabber.grabPos ~= nil and check == false and grabber.grabPos.x >= card.pos.x and grabber.grabPos.x <= card.pos.x + CARD_WIDTH and grabber.grabPos.y >= card.pos.y and grabber.grabPos.y <= card.pos.y + CARD_HEIGHT and card.grabbable == true and card.grabbed ~= true then 
        check = true
        -- sets current card to grabbed
        card.grabbed = true
        lowest = index
        -- sets above cards to not grabbed, sets below cards to be grabbed
        for newIndex, newCard in ipairs(stack.cards) do
          newCard.grabbed = false
          if lowest <= newIndex and grabber.grabPos.y >= newCard.pos.y and grabber.grabPos.y <= newCard.pos.y + CARD_HEIGHT then
            lowest = newIndex
            newCard.grabbed = true
            if lowest ~= 1 then
              stack.cards[lowest-1].grabbed = false
            end
          elseif lowest <= newIndex then
            newCard.grabbed = true
          end
        end
      end
  
      if card.grabbed == true and grabber.grabPos == nil then
        --lets go of the card when the player releases
        card.grabbed = false
        check = false
        for _, newStack in ipairs(stackTable) do 
          if grabber.currentMousePos.x >= newStack.pos.x and grabber.currentMousePos.x <= newStack.pos.x + CARD_WIDTH and grabber.currentMousePos.y >= newStack.pos.y and grabber.currentMousePos.y <= newStack.pos.y + ((#newStack.cards)*newStack.offset + CARD_HEIGHT) then
            table.remove(stack.cards, index)
            table.insert(newStack.cards, card)
          end
        end
      end
      if card.grabbed then
        card.pos = Vector(grabber.currentMousePos.x - .5*CARD_WIDTH, grabber.currentMousePos.y - (.5*CARD_HEIGHT - CARD_OFFSET*grabbedCards))
        grabbedCards = grabbedCards + 1
      end
    end
    stack:update()
  end
  
  
  --fix this later
  if grabber.grabPos ~= nil and grabber.grabPos.x >= grabStack.pos.x and grabber.grabPos.x <= grabStack.pos.x + CARD_WIDTH and grabber.grabPos.y >= grabStack.pos.y and grabber.grabPos.y <= grabStack.pos.y + CARD_HEIGHT then
    if #grabStack.cards == 0 then
      while #tempStack ~= 0 do
        table.insert(grabStack.cards,tempStack[1])
        table.remove(tempStack,1)
      end
    elseif #newCardStack.cards == 0 then
      table.insert(newCardStack.cards, grabStack.cards[1])
      table.insert(newCardStack.cards, grabStack.cards[2])
      table.insert(newCardStack.cards, grabStack.cards[3])
      table.remove(grabStack.cards,1)
      table.remove(grabStack.cards,1)
      table.remove(grabStack.cards,1)
    else
      table.insert(tempStack, newCardStack.cards[1])
      table.insert(tempStack, newCardStack.cards[2])
      table.insert(tempStack, newCardStack.cards[3])
      table.remove(newCardStack.cards,1)
      table.remove(newCardStack.cards,1)
      table.remove(newCardStack.cards,1)
      table.insert(newCardStack.cards, grabStack.cards[1])
      table.insert(newCardStack.cards, grabStack.cards[2])
      table.insert(newCardStack.cards, grabStack.cards[3])
      table.remove(grabStack.cards,1)
      table.remove(grabStack.cards,1)
      table.remove(grabStack.cards,1)
    end
  end

end

function love.draw()
  for _, stack in ipairs(stackTable) do
    for _, card in ipairs(stack.cards) do
      card:draw()
    end
  end
  
  for _, card in ipairs(grabStack.cards) do
    card:draw()
  end
  
  for _, card in ipairs(newCardStack.cards) do
    card:draw()
  end
end
