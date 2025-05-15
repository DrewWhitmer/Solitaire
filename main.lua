-- Drew Whitmer
-- CMPM 121 - Solitaire
-- 4/8/2025


io.stdout:setvbuf("no")

iffy = require "iffy"
iffy.newAtlas("/assets/playingCards.png")

CARD_OFFSET = 20
SUITS = {
  CLUBS = "Clubs",
  SPADES = "Spades",
  HEARTS = "Hearts",
  DIAMONDS = "Diamonds"
}

BUTTON_XPOS = 0
BUTTON_YPOS = 500
WIN_XPOS = 230
WIN_YPOS = 300

function love.load()
  require "card"
  require "grabber"
  require "stack"
  
  love.window.setTitle("Solitaire")
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  resetButton = love.graphics.newImage('/assets/resetButton.png')
  winText = love.graphics.newImage('/assets/winText.png')
  
  
  stackTable = {}
  
  table.insert(stackTable, StackClass:new({}, 200, 200))
  table.insert(stackTable, StackClass:new({}, 300, 200))
  table.insert(stackTable, StackClass:new({}, 400, 200))
  table.insert(stackTable, StackClass:new({}, 500, 200))
  table.insert(stackTable, StackClass:new({}, 600, 200))
  table.insert(stackTable, StackClass:new({}, 700, 200))
  table.insert(stackTable, StackClass:new({}, 800, 200))
  
  deckStack = DeckStackClass:new({}, 50, 50)
  grabStack = GrabStackClass:new({}, 50, 170)
  tempStack = {}
  table.insert(stackTable, grabStack)
  
  table.insert(stackTable, FinalStackClass:new({}, 200, 50, SUITS.HEARTS))
  table.insert(stackTable, FinalStackClass:new({}, 400, 50, SUITS.DIAMONDS))
  table.insert(stackTable, FinalStackClass:new({}, 600, 50, SUITS.CLUBS))
  table.insert(stackTable, FinalStackClass:new({}, 800, 50, SUITS.SPADES))
  
  buttonCheck = false
  deckCheck = false
  
  grabbedCards = {}
  
  start()
  hasWon = false
end

function love.update()
  if grabbedCards ~= nil then
    for index, card in ipairs(grabbedCards) do
      card.pos = Vector(grabber.currentMousePos.x - .5*CARD_WIDTH, grabber.currentMousePos.y - (.5*CARD_HEIGHT - CARD_OFFSET*index))
    end
  end
  
  local winCounter = 0
  for _, stack in ipairs(stackTable) do
    stack:update()
    if stack:checkForWin() then
      winCounter = winCounter + 1
    end
  end
  if winCounter == 4 then
    hasWon = true
  end
  
  deckStack:update()
  grabber:update()
  
  --if player clicks on deck, 3 cards will be drawn
  if grabber.grabPos ~= nil and grabber.grabPos.x >= deckStack.pos.x and grabber.grabPos.x <= deckStack.pos.x + CARD_WIDTH and grabber.grabPos.y >= deckStack.pos.y and grabber.grabPos.y <= deckStack.pos.y + CARD_HEIGHT and deckCheck == false then
    deckCheck = true
    if #deckStack.cards == 0 then
      while #tempStack ~= 0 do
        tempStack[1].flipped = true
        table.insert(deckStack.cards, tempStack[1])
        table.remove(tempStack,1)
      end
    end
    removeAndInsert(grabStack.cards, tempStack)
    removeAndInsert(deckStack.cards, grabStack.cards)
    deckStack:update()
    grabStack:update()
  end
  --moves cards in temp stack away from player view
  for _,card in ipairs(tempStack) do
    card.pos = Vector(love.window.getMode())
  end
  
  if grabber.grabPos ~= nil and grabber.grabPos.x >= BUTTON_XPOS and grabber.grabPos.x <= BUTTON_XPOS + resetButton:getWidth() and grabber.grabPos.y >= BUTTON_YPOS and grabber.grabPos.y <= BUTTON_YPOS + resetButton:getHeight() and buttonCheck == false then
    buttonCheck = true
    tempStack = {}
    for _, stack in ipairs(stackTable) do
      stack.cards = {}
    end
    start()
    hasWon = false
  end
  
  
  if grabber.grabPos == nil then
    deckCheck = false
    buttonCheck = false
  end
  
end

function love.mousepressed()
  grabbedCards = grabber:grab(stackTable)
end

function love.mousereleased()
  grabbedCards = grabber:release(stackTable, grabbedCards)
end

function removeAndInsert(t1, t2)
  if(#t1 >= 3) then
    j = 3
  elseif #t1 == 0 then
    return
  else
    j = #t1
  end
  
  for i = 1,j do
    t1[1].flipped = false
    table.insert(t2, t1[1])
    table.remove(t1, 1)
  end
  
end

function start()
  local deck = {}
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
  
  for i = 1, 7 do
    for j = 1, i do
      local card = deck[1]
      table.remove(deck, 1)
      table.insert(stackTable[i].cards, card)
    end
    stackTable[i]:update()
  end
  
  deckStack.cards = deck
end


function love.draw()
  deckStack:draw()
  
  for _, stack in ipairs(stackTable) do
    stack:draw()
    for _, card in ipairs(stack.cards) do
      card:draw()
    end
  end
  
  for _, card in ipairs(grabStack.cards) do
    card:draw()
  end
  
  love.graphics.draw(resetButton, BUTTON_XPOS, BUTTON_YPOS)
  if hasWon then
    love.graphics.draw(winText, WIN_XPOS, WIN_YPOS)
  end
  
  if grabbedCards == nil then
    return
  end
  
  for _, card in ipairs(grabbedCards) do
    card:draw()
  end
  
  
  
end
