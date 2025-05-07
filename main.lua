-- Drew Whitmer
-- CMPM 121 - Solitaire
-- 4/8/2025
io.stdout:setvbuf("no")

iffy = require "iffy"
iffy.newAtlas("/assets/playingCards.png")
require "card"
require "grabber"
require "stack"

CARD_OFFSET = 20
SUITS = {
  CLUBS = "Clubs",
  SPADES = "Spades",
  HEARTS = "Hearts",
  DIAMONDS = "Diamonds"
}


function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  deck = {}
  
  --put all cards into one table
  for i = 1, 13 do
    table.insert(deck, CardClass:new(SUITS.CLUBS, i, true, true, false, 0, 0))
  end
  for i = 1, 13 do
    table.insert(deck, CardClass:new(SUITS.SPADES, i, true, true, false, 0, 0))
  end
  for i = 1, 13 do
    table.insert(deck, CardClass:new(SUITS.DIAMONDS, i, true, true, false, 0, 0))
  end
  for i = 1, 13 do
    table.insert(deck, CardClass:new(SUITS.HEARTS, i, true, true, false, 0, 0))
  end
  
  stackTable = {}
  
  table.insert(stackTable, StackClass:new({}, 200, 200, CARD_OFFSET,false))
  table.insert(stackTable, StackClass:new({}, 300, 200, CARD_OFFSET,false))
  table.insert(stackTable, StackClass:new({}, 400, 200, CARD_OFFSET,false))
  table.insert(stackTable, StackClass:new({}, 500, 200, CARD_OFFSET,false))
  table.insert(stackTable, StackClass:new({}, 600, 200, CARD_OFFSET,false))
  table.insert(stackTable, StackClass:new({}, 700, 200, CARD_OFFSET,false))
  table.insert(stackTable, StackClass:new({}, 800, 200, CARD_OFFSET,false))
  
  math.randomseed(os.time())
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
  newCardStack = StackClass:new({},50,170,CARD_OFFSET,false)
  tempStack = {}
  
  for i = 1, 7 do
    for j = 1, i do
      local card = deck[1]
      table.remove(deck, 1)
      table.insert(stackTable[i].cards, card)
    end
    stackTable[i]:update()
  end
  
  table.insert(stackTable,newCardStack)
  
  table.insert(stackTable, StackClass:new({}, 200, 50, 0, true, SUITS.HEARTS))
  table.insert(stackTable, StackClass:new({}, 400, 50, 0, true, SUITS.DIAMONDS))
  table.insert(stackTable, StackClass:new({}, 600, 50, 0, true, SUITS.CLUBS))
  table.insert(stackTable, StackClass:new({}, 800, 50, 0, true, SUITS.SPADES))
  
  check1 = false
  check2 = false
  
  
end

function love.update()
  
  grabber:update()
  grabbedCards = 0
  for _, stack in ipairs(stackTable) do
    for index, card in ipairs(stack.cards) do
      --checks if grab is happening and if the grab position is on the card
      if grabber.grabPos ~= nil and check1 == false and grabber.grabPos.x >= card.pos.x and grabber.grabPos.x <= card.pos.x + CARD_WIDTH and grabber.grabPos.y >= card.pos.y and grabber.grabPos.y <= card.pos.y + CARD_HEIGHT and card.grabbable == true and card.grabbed ~= true then
        check1 = true
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
  
      if card.grabbed and grabber.grabPos == nil then
        --lets go of the card when the player releases
        card.grabbed = false
        check1 = false
        for _, newStack in ipairs(stackTable) do 
          if grabber.currentMousePos.x >= newStack.pos.x and grabber.currentMousePos.x <= newStack.pos.x + CARD_WIDTH and grabber.currentMousePos.y >= newStack.pos.y and grabber.currentMousePos.y <= newStack.pos.y + ((#newStack.cards)*newStack.offset + CARD_HEIGHT) then
            --make sure it goes in correct order, also prevents cheating
            if newStack.final and card.num == #newStack.cards + 1 and card.suit == newStack.suit then
              table.insert(newStack.cards, card)
              table.remove(stack.cards, index)
            elseif #newStack.cards == 0 then
              if card.num == 13 then
                table.insert(newStack.cards, card)
                table.remove(stack.cards, index)
              end
            elseif not newStack.final and (newStack.pos.x ~= stack.pos.x or newStack.pos.y ~= stack.pos.y) then
              checkCard(stack, newStack, card, index)
            end
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
  
  
  --if player clicks on deck, 3 cards will be drawn
  if grabber.grabPos ~= nil and grabber.grabPos.x >= grabStack.pos.x and grabber.grabPos.x <= grabStack.pos.x + CARD_WIDTH and grabber.grabPos.y >= grabStack.pos.y and grabber.grabPos.y <= grabStack.pos.y + CARD_HEIGHT and check2 == false then
    check2 = true
    if #grabStack.cards == 0 then
      while #tempStack ~= 0 do
        tempStack[1].flipped = true
        table.insert(grabStack.cards,tempStack[1])
        table.remove(tempStack,1)
      end
    elseif #newCardStack.cards == 0 then
      removeAndInsert(grabStack.cards,newCardStack.cards)
      grabStack:update()
      newCardStack:update()
    else
      removeAndInsert(newCardStack.cards,tempStack)
      removeAndInsert(grabStack.cards,newCardStack.cards)
      grabStack:update()
      newCardStack:update()
    end
  end
  
  --makes sure cards in the grab stack are flipped
  for _,card in ipairs(grabStack.cards) do
    card.flipped = true
  end
  
  if #newCardStack.cards ~= 0 then
    for _, card in ipairs(newCardStack.cards) do
      card.grabbable = false
    end
    newCardStack.cards[#newCardStack.cards].grabbable = true
  end
  
  --moves cards in temp stack away from player view
  for _,card in ipairs(tempStack) do
    card.pos = Vector(love.window.getMode())
  end
  
  if grabber.grabPos == nil then
    check2 = false
  end
  
end

function removeAndInsert(t1,t2)
  if(#t1 >= 3) then
    j = 3
  elseif #t1 == 0 then
    return
  else
    j = #t1
  end
  
  for i = 1,j do
    t1[1].flipped = false
    table.insert(t2,t1[1])
    table.remove(t1,1)
  end
  
end

function checkCard(stack1, stack2, card, index)
  if card.num == stack2.cards[#stack2.cards].num - 1 and (stack2.cards[#stack2.cards].suit == SUITS.DIAMONDS or stack2.cards[#stack2.cards].suit == SUITS.HEARTS) and (card.suit == SUITS.CLUBS or card.suit == SUITS.SPADES) then 
    table.insert(stack2.cards, card)
    table.remove(stack1.cards, index)
  elseif card.num == stack2.cards[#stack2.cards].num - 1 and (stack2.cards[#stack2.cards].suit == SUITS.CLUBS or stack2.cards[#stack2.cards].suit == SUITS.SPADES) and (card.suit == SUITS.DIAMONDS or card.suit == SUITS.HEARTS) then 
    table.insert(stack2.cards, card)
    table.remove(stack1.cards, index)
  end
  
end

function love.draw()
  for _, stack in ipairs(stackTable) do
    stack:draw()
    for _, card in ipairs(stack.cards) do
      card:draw()
    end
  end
  
  for _, card in ipairs(grabStack.cards) do
    card:draw()
  end
  
end
