-- Made by Nothy on itch.io
-- Redistribution & modification allowed.


local buttons = {
}
buttonAPI = {
  version = "version 1.0",
}

function buttonAPI:checkClick(x,y, uiLayout)
  if not uiLayout then
    uiLayout = "all"
  end
  for k,v in pairs(buttons) do
    if x >= buttons[k].x and x <= buttons[k].x + buttons[k].width and y >= buttons[k].y and y <= buttons[k].y + buttons[k].height and buttons[k].clickable then
      if uiLayout == buttons[k].uiLayout then
        return buttons[k].name
      elseif uiLayout == "all" then
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
function buttonAPI:drawButton(name)
  if buttons[name] ~= nil then
    if buttons[name].clickable then
      love.graphics.setColor(255,255,255)
    else
      love.graphics.setColor(150,150,150)
    end
    love.graphics.rectangle("fill",buttons[name].x, buttons[name].y, buttons[name].width, buttons[name].height)
    love.graphics.setColor(10,10,10)
    love.graphics.print(buttons[name].label,buttons[name].x, buttons[name].y+(buttons[name].height/2))
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
return buttonAPI
