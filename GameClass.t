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
    export (points, cards, playerBet, folded, called, bet, call, uncall, fold, unfold, clearBet)

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

    procedure call
	called := true
    end call

    procedure uncall
	called := false
    end uncall

    procedure fold
	folded := true
    end fold

    procedure unfold
	folded := false
    end unfold

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
	dealPile -> shuffle
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
	    communityPile -> addCard (dealPile -> pop)
	end for
    end dealCommunity

    procedure call (n : int)
	for i : 0 .. 3
	    if players (n) -> playerBet < players (i) -> playerBet then
		players (n) -> bet (players (i) -> playerBet - players (n) -> playerBet)
	    end if
	end for
	players (n) -> call
    end call

    procedure raise (n, a : int)
	players (n) -> bet (a)
	for i : 0 .. 3
	    players (n) -> uncall
	end for
    end raise

    procedure fold (n : int)
	players (n) -> fold
    end fold

    procedure allIn (n : int)
	players (n) -> bet (players (n) -> points)
    end allIn

    procedure endRound
	var foldNum := 0
	for i : 0 .. 3
	    if players (i) -> folded then
		foldNum += 1
	    end if
	end for
	if players (0) -> called and players (1) -> called and players (2) -> called and players (3) -> called then % when all players have called
	    for i : 0 .. 3
		players (i) -> uncall %all players uncall
	    end for
	    for i : 0 .. 3
		pot += players (i) -> playerBet %put all money into pot
		players (i) -> clearBet
	    end for
	elsif foldNum = 3 then % when all but one player fold

	    for i : 0 .. 3
		players (i) -> uncall %all players uncall
	    end for
	    for i : 0 .. 3
		pot += players (i) -> playerBet %put all money into pot
		players (i) -> clearBet
	    end for

	end if
    end endRound

    function checkWin : int
	% Check using bfs : all possible pokerHands : all possible hands
	var highestPH : ^pokerHand
	var highestHand : ^hand
	var playerInt : int

	new pokerHand, highestPH
	new hand, highestHand

    end checkWin

end game
