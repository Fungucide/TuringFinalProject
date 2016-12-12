include "CardClass.t"
var s : ^deckOfCards
new deckOfCards, s

var cards : array 1 .. 13, 1 .. 4 of ^card

for i : 1 .. 5
    for h : 1 .. 4
	new card, cards (i, h)
	cards (i, h) -> setValues (i, h)
	s -> push (cards (i, h))
    end for
end for

var t : ^card
new card, t

s -> shuffle

s -> listAll
