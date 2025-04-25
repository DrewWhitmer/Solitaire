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
  
  --click
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
  
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
end

function GrabberClass:release()
  
  self.grabPos = nil
  
end