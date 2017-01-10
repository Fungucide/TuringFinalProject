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

    import card, hand, sort, deckOfCards, player, pokerHand, straightFlush, quad, fullHouse, flush, straight, triple, twoPair, pair

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
		players (i) -> uncall
	    end for
	    for i : 0 .. 3
		pot += players (i) -> playerBet
		players (i) -> clearBet
	    end for
	elsif foldNum = 3 then

	    for i : 0 .. 3
		players (i) -> uncall
	    end for
	    for i : 0 .. 3
		pot += players (i) -> playerBet
		players (i) -> clearBet
	    end for

	end if
    end endRound

    function checkWin : int
	% Check using bfs : all possible pokerHands : all possible hands
	var highestPH : ^pokerHand
	var highestHand : ^hand
	var playerInt : flexible array 0 .. -1 of int
	var setValues := false
	var flag := true

	new pokerHand, highestPH
	new hand, highestHand

	% General Arrays for storing cards
	var allCards : array 0 .. 6 of ^card
	var pokerHandCheck : flexible array 0 .. -1 of ^card
	var playerHand : array 0 .. 1 of ^card

	% Variables for checking straightFlush or flush
	var suitCount : array 1 .. 4 of int := init (0, 0, 0, 0)
	var count : int := 0
	var startIndex : int := -1
	var previousValue := -1

	% For every Player
	for i : 0 .. 3

	    % Make sure player has not folded
	    if players (i) -> folded = true then

		% Get Their cards and add them to all Cards
		players (i) -> cards -> getCards (playerHand)
		communityPile -> getCards (allCards)
		allCards (5) := playerHand (0)
		allCards (6) := playerHand (1)

		% Flag to see if set found matching requirements
		flag := true

		% Sort the cards
		sort (allCards)

		% Go through the cards and look for flush first
		for h : 0 .. 6
		    suitCount (allCards (h) -> suit) += 1
		end for

		% Take the cards that have the same suit
		for suit : 1 .. 4
		    if suitCount (suit) >= 5 then
			for h : 0 .. 6
			    if allCards (h) -> suit = suit then
				new pokerHandCheck, upper (pokerHandCheck) + 1
				pokerHandCheck (upper (pokerHandCheck)) := allCards (h)
				if allCards (h) -> value = 14 then
				    var lowAce : ^card
				    new card, lowAce
				    lowAce -> setValues (1, allCards (h) -> suit)
				    new pokerHandCheck, upper (pokerHandCheck) + 1
				    pokerHandCheck (upper (pokerHandCheck)) := lowAce
				end if
			    end if
			end for
			exit
		    else
			flag := false
		    end if
		end for

		% Check for a straight
		if flag then
		    sort (pokerHandCheck)
		    flag := false
		    for decreasing h : upper (pokerHandCheck) - 1 .. 0
			if pokerHandCheck (h + 1) -> value - pokerHandCheck (h) -> value = 1 then
			    count += 1
			else
			    count := 0
			end if

			if count = 5 then
			    flag := true
			    startIndex := h
			    exit
			end if
		    end for
		end if

		% Check to see if it is the highest straight flush
		if flag then
		    var sf : ^straightFlush
		    new straightFlush, sf
		    var sfCards : array 0 .. 4 of ^card
		    for h : 0 .. 4
			sfCards (h) := pokerHandCheck (startIndex - h)
		    end for
		    sf -> setCards (sfCards)
		    if setValues then
			if sf -> compare (highestPH) = 1 then
			    highestPH := sf
			    highestHand := players (i) -> cards
			    new playerInt, 0
			    playerInt (0) := i
			elsif sf -> compare (highestPH) = 0 then
			    new playerInt, upper (playerInt) + 1
			    playerInt (upper (playerInt)) := i
			end if
		    else
			setValues := true
			highestPH := sf
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    end if
		end if

		% Check for quad
		for h : 0 .. 6
		    if allCards (h) -> value = previousValue then
			count += 1
		    else
			previousValue := allCards (h) -> value
			count := 1
		    end if

		    if count = 4 then
			startIndex := h
			exit
		    end if
		end for

		if count = 4 then
		    var q : ^quad
		    new quad, q
		    var qCards : array 0 .. 3 of ^card
		    for h : 0 .. 3
			qCards (h) := allCards (startIndex - h)
		    end for
		    q -> setCards (qCards)
		    if setValues then
			if q -> compare (highestPH) = 1 then
			    highestPH := q
			    highestHand := players (i) -> cards
			    new playerInt, 0
			    playerInt (0) := i
			elsif q -> compare (highestPH) = 0 then
			    sort (playerHand)
			    var highestCard : ^card
			    new card, highestCard
			    highestCard := playerHand (1)
			    highestHand -> getCards (playerHand)
			    sort (playerHand)
			    if highestCard -> compare (playerHand (1)) = 1 then
				highestPH := q
				highestHand := players (i) -> cards
				new playerInt, 0
				playerInt (0) := i
			    end if
			end if
		    else
			setValues := true
			highestPH := q
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    end if
		end if

	    end if

	end for
    end checkWin

end game
