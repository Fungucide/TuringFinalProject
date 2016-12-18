% GameClass.t
% Dec 17, 2016
% William Fung
% Poker Hands

% Updates
% ---------------------
% Dec 17, 2016
% - Initial Creation of file
% -

include "PokerHands.t"

class player

    import card, hand, sort
    export (points, cards)

    var points : int := 2000
    var cards : ^hand
    new hand, cards

end player

class game

    import card, hand, sort, deckOfCards, player

    var dealPile : ^deckOfCards
    var burnPile : ^deckOfCards
    var communityPile : ^hand
    var players : array 0 .. 3 of ^player
    new deckOfCards, dealPile
    new deckOfCards, burnPile
    new hand, communityPile

    procedure initialize (c : array 0 .. * of ^card)
	for i : 0 .. upper (c)
	    dealPile -> push (c (i))
	end for
	for i : 0 .. 3
	    new player, players (i)
	end for
    end initialize

end game
