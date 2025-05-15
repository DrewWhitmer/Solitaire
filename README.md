Patterns:

I used prototypes in order to create different stack classes. This way, instead of having different variables to account for what different types of stacks should do,
it is hard coded to the different types of stacks, making the classes more readable and expandable.

Feedback:

Nathan Skinner: pointed out some bugs, spacing in tables. I went through and made it so every table has consistent spacing. Bugs were fixed throughout the process of 
refactoring.

Henry Christopher: clean up main.lua, have helper functions to check for long if statements, change confusing variable names. I changed it so the check variables have
more specific names, changed it so that certain if statements were spread across a function (stack:checkCard()).

Sean Massa: use grabber class to clean up update loop, use longer variable names when making classes. I changed the names of the constructor variables in card.lua to
match what they become in the actual class. I used the grabber class to update the moving cards logic.

Postmortem:

I think that I did a pretty good job refactoring the code. My main goal was to make main.lua and the update loop shorter and more readable, which I think I did a good
job of. I did this by having the stack class have multiple subclasses for my different needs, as well as spreading the moving card logic to stack.lua and grabber.lua.
I also wanted to fix the bugs in the previous solitaire in doing so, which I was able to. 

Credit:

Got card faces/backs from https://opengameart.org/content/boardgame-pack, did images for the specific suit stacks myself.
Used some lecture code throughout the project, especially in grabber.lua and for the modern fisher-yates method.
I also use the iffy helper library https://github.com/besnoi/iffy to read the xml file for the card sprites.