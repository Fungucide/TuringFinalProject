include "CardClass.t"
include "PokerHands.t"
/*
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
 */

var ph : array 0 .. 8 of ^pokerHand
var p : ^pair
new pair, p
var pc1 : ^card
new card, pc1
pc1 -> setValues (1, 1)
var pc2 : ^card
new card, pc2
pc2 -> setValues (1, 2)
var pca : array 0 .. 1 of ^card
pca (0) := pc1
pca (1) := pc2
p -> setCards (pca)
