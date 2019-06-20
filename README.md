# Nothy's Button API documentation
***
Nothy's Button API is an API aiming to make buttons far easier to make in Love2D, whereas *other* APIs have only added extra steps to making buttons. Nothy's Button API is made to be as simple and straightforward as possible.
***
### Importing the API into your project.
You can import Nothy's Button API as you would with any other API in Lua.
```lua
local buttons = require '<apiDirectory>.buttonAPI'
```
Keep in mind that if you have the API saved anywhere other than apis/buttonAPI.lua, you will have to change the import code to reflect those changes.
Say you have the API saved in *MyDirectory/buttonAPI.lua*, then the import code would be as follows:
```lua
local buttons = require  'MyDirectory.buttonAPI'
```
***
### Creating and removing buttons using the API
Button creation with Nothy's Button API is as simple as it can get. To begin with, you have to determine where you'd want the button (pixel coordinates), and what size it should be (in pixels).
Now, in ``love.load()`` simply put this:

**NOTE: It is assumed that you've imported the API as buttons.**
```lua
function love.load()
  buttons:createButton("example","Example button",158,150,100,52,uiLayout)
end
```
In this case, the first string variable 'example', is the button name that you will be looking for when looking for clicks. The second string variable is the label, it is what the user will see when the program is running.

A thing worth noting is that if you make the text *wider* than the button, the API will automatically adjust the width of the button to accomodate for this.


The first integer is the X position of the button, the second integer is the Y position of the button. The two last integers are the width and height of the button.
The final variable called uiLayout is something we will dive deeper into in the next section.

**Keep in mind that creating new buttons in ``love.update()`` or any continuous loop is HEAVILY discouraged for very obvious reasons.**

**Added in version 1.1**
You can move a button as well, by simply calling this method:
```lua
buttons:moveButton("example", newPositionX, newPositionY)
```
or if you'd like to animate where the button is going, you can simply call the following method:
```lua
buttons:moveTowards("example",newPositionX, newPositionY, speed)
```
*NOTE:* Keep in mind that when your DeltaTime is high, ``:moveTowards()`` can sometimes act very strangely. At the moment the cause for this is unknown, but is being looked into.

Removing buttons in the API is about as simple as creating them, if not simpler.

When removing a button, simply run the following snippet of code:
```lua
buttons:removeButton("example")
```
Of course, you'd want to use your own button name, and not use example all the time. Please keep in mind that once you remove the button, you will have to create a new one with the same properties to get it back.
***
### What are uiLayouts and how do I use them?
A uiLayout is simply a string of text that defines what layout a button is part of.
If you create a button that has the uiLayout ``example``, then you render that uiLayout, only those with the uiLayout ``example`` will be rendered.
Using this knowledge, you can create complex UIs.

How do I use uiLayouts?

The simplest way to use a uiLayout is to have a table of various layout names as such:
```lua
local layouts =  {
  "main menu",
  "pause menu",
  "settings menu",
}
local currentLayoutIndex = 1
```
Keep in mind that the API does not care about spaces, it'll simply work.
You can use numbers as well for uiLayouts, though being discouraged it is possible.

When you render, you simply do this:

```lua
function love.draw()
  buttons:drawAllButtons(layouts[currentLayoutIndex])
end
```
You can leave the uiLayout variable of ``:drawAllButtons()`` empty, then the API will automatically set it to ``all``, which as the name suggests, renders *all* the layouts.
***
### Adding buttons to a uiLayout
Adding a button to a uiLayout is simple.
If you have a uiLayout called ``main``, you'd simply pass in a string into the *final* variable of ``:createButton()``

```lua
function love.load()
  buttons:createButton("example","Example button",158,150,100,52,"main") -- I will be rendered
  buttons:createButton("example","Example button",158,150,100,52,"not main") -- I will not be rendered
end
function love.draw()
  buttons:drawAllButtons("main")
end
```
***
### Rendering buttons
If you have a uiLayout, please look in ``What are uiLayouts and how do I use them?``
Otherwise you can simply render every button as-is with the following bit of code:
```lua
function love.draw()
  buttons:drawAllButtons()
end
```
***
### Clicking on buttons
When you have a button, in this case we'll use the example button, you can set it as clickable or not without any effort at all.
All you have to do is run the following command:
```lua
buttons:setClickable("example",false) -- Button is no longer clickable.
buttons:setClickable("example",true) -- Button is clickable again - woohoo!
```
Now, you'll most likely want to have a button be *clickable* and not just show whether or not it is.

There was really only one way of doing it, and that was to have some code within ``love.mousepressed()`` that simply compares where the user clicked and the layout bounds of the buttons. This sounds complicated, but in reality it was about as easy as creating a button.
There was a built in command in Nothy's Button API that did this for you, and returned which button was pressed.
It was used like this:
```lua
function love.onmousepressed(x, y, button, isTouch)
  local clickedButton = buttons:checkClick(x,y)
  print(clickedButton)
end
```
If we were to click on the button ``example`` the variable clickedButton would be ``example``. Knowing this you could make very complicated UIs with ease, such as this:
```lua
function love.onmousepressed(x, y, button, isTouch)
  local clickedButton = buttons:checkClick(x,y)
  if clickedButton == "goToMainMenu" then
    goToMainMenu()
  end
end
```
However, I changed it up for Nothy, like so:
```lua
buttons:addListener(button, function)
```
That's it! Much easier now. It works exactly the same way, too! Add a function, and it'll be called, including the `button` and `isTouch` parameters.
If you want to listen for normal clicks too, use:
```lua
buttons:clickListener(function)
```
and it will call `function` with all 4 params.
