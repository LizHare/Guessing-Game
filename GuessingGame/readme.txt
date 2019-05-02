ReadMe
Elizabeth Hare

iOS Coding Sample Project 1 - Guess the correct price game
Guessing Game v0.0.1

Guessing game is a game where you have a set amount of time to guess the price of various 
blenders.

The game is written in Obj-c and will compile for iPhone.

It runs in portrait mode on a 5/5s/6/6Plus.

Each round will last 30 seconds, and you have that amount of time to guess the price
of as many blenders as you can by tapping the correct price. A correct guess can yield a
maximum of 4 pts, while each incorrect guess subtracts one from that number (down to 0). 
When the correct price is chosen, the next object and price will be shown until there is
no more time. At that point the user will be shown their score and whether they have
gotten the new high score.

At any point the user can opt out and return to the rules screen, or during guessing
to the score screen. 

If all products have been exhausted in one round(there are about 47~) the user will be 
congratulated and taken to the score screen. 

I used core data to save product information and to save out user high scores. 
The allows for the user to challenge themselves, and offline play.

Also we show the user the manufacturer and product name to give more context about the
product.

This code was written for a code test over approximately 4 hours (with clean up/presentation/refactoring).
