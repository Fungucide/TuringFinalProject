% GameClass.t
% Dec 17, 2016
% William Fung
% Max Tang
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
    var playerBet : int := 0
    var folded : boolean := false
    var called : boolean := false
    var cards : ^hand
    new hand, cards

    procedure bet (p : int)
	points -= p
	playerBet += p
    end bet

    procedure win (p : int)
	points += p
    end win

    procedure clearBet
	playerBet := 0
    end clearBet

end player

class game

    import card, hand, sort, deckOfCards, player

    var dealPile : ^deckOfCards
    var burnPile : ^deckOfCards
    var communityPile : ^hand
    var players : array 0 .. 3 of ^player
    var minBet : int := 100
    var smallBlind : boolean := true
    var bigBlind : boolean := true
    var dealerPos : int := Rand.Int (0, 3)
    var pot : int := 0
    new deckOfCards, dealPile
    new deckOfCards, burnPile
    new hand, communityPile

    procedure initialize (c : array 0 .. * of ^card)
	for i : 0 .. upper (c)
	    dealPile -> push (c (i))
	end for
	dealPile -> suffle
	for i : 0 .. 3
	    new player, players (i)
	end for
    end initialize

    procedure dealPlayer
	for n : 0 .. 3
	    players (n) -> cards -> addCard (dealPile -> pop)
	    players (n) -> cards -> addCard (dealPile -> pop)
	end for
    end dealPlayer

    procedure dealCommunity (i : int)
	burnPile -> push (dealPile -> pop)
	for n : 0 .. i
	    communityPile -> cards -> addCard (dealPile -> pop)
	end for
    end dealCommunity

end game
