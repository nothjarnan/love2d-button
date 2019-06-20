-- Made by Nothy on itch.io
-- Redistribution & modification allowed.


local buttons = {
}
local clickListener = null
buttonAPI = {
  version = "version 1.1",
}

function buttonAPI:checkClick(x,y, uiLayout)
  if not uiLayout then
    uiLayout = "all"
  end
  for k,v in pairs(buttons) do
    if x >= buttons[k].x and x <= buttons[k].x + buttons[k].width and y >= buttons[k].y and y <= buttons[k].y + buttons[k].height and buttons[k].clickable then
      if uiLayout == buttons[k].uiLayout then
        buttons[k].beingClicked = true
        buttons[k].clickTime = love.timer.getTime()
        --print(love.timer.getTime())
        return buttons[k].name

      elseif uiLayout == "all" then
        buttons[k].beingClicked = true
        buttons[k].clickTime = love.timer.getTime()
        --print(love.timer.getTime())
        return buttons[k].name
      end
    end
  end
end
function buttonAPI:setClickable(button, clicky)
  if not clicky then
    clicky = true
  end
  buttons[button].clickable = clicky
end
function buttonAPI:getButton(button)

  for k,v in pairs(buttons) do
    if k == button then
      return k
    end
  end
  return nil
end
function buttonAPI:getButtonPos(name)
  if buttons[name] ~= nil then
    return buttons[name].x, buttons[name].y
  else
    return 0,0
  end
end
function buttonAPI:moveButton(name,newposX, newposY)
  if buttons[name] ~= nil then
    buttons[name].x = newposX
    buttons[name].y = newposY
  end
end
function buttonAPI:updateLabel(name,newLabel)
  if buttons[name] ~= nil then
    buttons[name].label = newLabel
  end
end
function buttonAPI:setHoverable(name, hoverable)
  if buttons[name] ~= nil then
    buttons[name].hoverable = hoverable
  end
end
function buttonAPI:createButton(name, label, x, y, width, height, uiLayout)
  if not uiLayout then
    uiLayout = "all"
  end
  buttons[name] = {}
  buttons[name].label = label
  buttons[name].name = name
  buttons[name].uiLayout = uiLayout

  buttons[name].x = x
  buttons[name].y = y
  buttons[name].width = width
  buttons[name].height = height
  buttons[name].clickable = true
  buttons[name].setHoverable = true
  buttons[name].isHovered = false
  buttons[name].beingClicked = false
  buttons[name].clickTime = 0
  buttons[name].hoverColor = {
    r = 235,
    g = 235,
    b = 235,
    a = 255
  }
  buttons[name].moving = false
  buttons[name].newPos = {
    x = 0,
    y = 0,
  }
  buttons[name].speed = 0
  print("Created new button "..name.." using uilayout "..uiLayout)
end
function buttonAPI:removeButton(name)
  for k,v in pairs(buttons) do
    if k == name then
      buttons[k] = nil
      return true
    end
  end
  return false
end
function buttonAPI:moveTowards(name,x,y, speed)
  if not speed then speed = 20 end
  buttons[name].moving = true
  buttons[name].newPos.x = x
  buttons[name].newPos.y = y
  buttons[name].speed = speed
end
function buttonAPI:getSpeed(name)
  if buttons[name] ~= nil then
    return buttons[name].speed
  else
    return 0
  end
end
function buttonAPI:drawButton(name)
  if buttons[name] ~= nil then
    if buttons[name].clickable then

      if buttons[name].isHovered then
        love.graphics.setColor(buttons[name].hoverColor.r,buttons[name].hoverColor.g,buttons[name].hoverColor.b)
      else
        love.graphics.setColor(210,210,210)
      end

    else
      love.graphics.setColor(150,150,150)

    end

    if buttons[name].beingClicked then
      love.graphics.setColor(255,255,255)
    end
    local requiredWidth = love.graphics.getFont():getWidth(buttons[name].label)
    if buttons[name].width <= requiredWidth then
          buttons[name].width = requiredWidth
          love.graphics.rectangle("fill",buttons[name].x, buttons[name].y, requiredWidth+4, buttons[name].height, 3, 3)
          love.graphics.setColor(10,10,10)
          love.graphics.print(buttons[name].label,buttons[name].x+2, buttons[name].y+(buttons[name].height/2)-(love.graphics.getFont():getHeight()/2))
    else
        love.graphics.rectangle("fill",buttons[name].x, buttons[name].y, buttons[name].width, buttons[name].height, 3, 3)
        love.graphics.setColor(10,10,10)
        love.graphics.print(buttons[name].label,buttons[name].x, buttons[name].y+(buttons[name].height/2)-(love.graphics.getFont():getHeight()/2))
    end


  end
end

function buttonAPI:drawAllButtons(uiLayout)
  if not uiLayout then
    uiLayout = "all"
  end
  for k,v in pairs(buttons) do
    if uiLayout == "all" or buttons[k].uiLayout == "all" then
      buttonAPI:drawButton(k)
    else
      if uiLayout == buttons[k].uiLayout or buttons[k].uiLayout == "all" then
        buttonAPI:drawButton(k)
      end
    end
  end
end
function buttonAPI:update(x,y)
  -- Delta time is convenient to get in runtime
  local dt = love.timer.getDelta()
  --print("DELTA: "..dt)
  if not x or not y then
    x, y = love.mouse.getPosition()
  end

  for k,v in pairs(buttons) do
    local previousPositionX, previousPositionY = buttons[k].x, buttons[k].y
    if buttons[k].moving then
      if buttons[k].x > buttons[k].newPos.x and buttons[k].newPos.x ~= buttons[k].x then
        buttons[k].x = buttons[k].x - buttons[k].speed*dt
      else
        if buttons[k].newPos.x ~= buttons[k].x then
          buttons[k].x = buttons[k].x + buttons[k].speed *dt
        end
      end
      if buttons[k].y > buttons[k].newPos.y and buttons[k].newPos.y ~= buttons[k].y then
        buttons[k].y = buttons[k].y - buttons[k].speed *dt
      else
        if buttons[k].newPos.y ~= buttons[k].y then
          buttons[k].y = buttons[k].y + buttons[k].speed *dt
        end
      end
      --print("SPEED:"..(previousPositionX + buttons[k].x)*dt)
      --print("POSITION: X"..buttons[k].x.." Y:"..buttons[k].y)
      -- if (previousPositionX - buttons[k].x)*dt < 0.001 then
      --   buttons[k].moving = false
      -- end
      if math.abs(buttons[k].newPos.x - buttons[k].x)*dt < 0.1 and math.abs(buttons[k].newPos.y - buttons[k].y)*dt < 0.1 then
        buttons[k].moving = false
        buttons[k].speed = 0
      end
      -- if buttons[k].x == buttons[k].newPos.x and buttons[k].y ==  buttons[k].newPos.y then
      --   buttons[k].moving = false
      -- end
    end
    if (buttons[k].clickTime+.1) - love.timer.getTime() <= 0 then
      buttons[k].beingClicked = false
      buttons[k].clickTime = 0
    else

    end
    if x >= buttons[k].x and x <= buttons[k].x + buttons[k].width and y >= buttons[k].y and y <= buttons[k].y + buttons[k].height and buttons[k].clickable then
      buttons[k].isHovered = true
    else
      buttons[k].isHovered = false
    end
  end
end
function buttonAPI:addListener(button, fun)
  buttons[button].listener = fun
end
function buttonAPI:clickListener(fun)
  clickListener = fun
end
function love.onmousepressed(x, y, clickType, isTouch)
  local buttonPressed = buttonAPI:checkClick(x, y)
  if buttons[buttonPressed].listener ~= null then
    buttons[buttonPressed].listener(clickType, isTouch)
  end
  if clickListener then clickListener(x, y, clickType, isTouch) end
end
return buttonAPI
