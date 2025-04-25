Patterns:

The only pattern that we have covered so far that I really used was the update loops to check for stuff like mouse clicks every frame.

Postmortem:

There are a lot of things that I think I could have done better. One thing that I think that I did do well was commenting stuff in the code that needed explaining, though I suppose that is hard to say if it is just me looking at the code. For what I would do differently, I think that I would use the state pattern for the cards so that there are not as many different variables that could be assigned to a state. I would also actually read the xml from the code so that there is not just a massive if/else statement for getting the card faces. I would also delegate more stuff to the stack/card classes so that main.lua is not as massive and hard to parce.

Credit:

Got card faces/backs from https://opengameart.org/content/boardgame-pack, did images for the specific suit stacks myself
Used some lecture code throughout the project, especially in grabber.lua and for the modern fisher-yates method.