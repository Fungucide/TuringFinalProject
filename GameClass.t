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
    export (points, cards, playerBet, folded, called, bet, call, uncall, fold, unfold, clearBet, win)

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

    import card, hand, sort, deckOfCards, player, pokerHand, straightFlush, quad, fullHouse, flush, straight, triple, twoPair, pair, single
    export (dealPile, burnPile, communityPile, players, smallBlind, bigBlind, dealerPos, pot, initialize, dealPlayer, dealCommunity, call, raise, fold, allIn, endRound, checkWin, setDeck, clearPot)

    var dealPile : ^deckOfCards
    var burnPile : ^deckOfCards
    var communityPile : ^hand
    var players : array 0 .. 3 of ^player
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

    procedure setDeck (c : array 0 .. * of ^card)
	var temp : ^card
	loop
	    temp := dealPile -> pop
	    exit when dealPile -> size = -1
	end loop
	for i : 0 .. upper (c)
	    dealPile -> push (c (i))
	end for
	dealPile -> shuffle
    end setDeck

    procedure dealPlayer
	for n : 0 .. 3
	    players (n) -> cards -> addCard (dealPile -> pop)
	    players (n) -> cards -> addCard (dealPile -> pop)
	end for
    end dealPlayer

    procedure dealCommunity (i : int)
	burnPile -> push (dealPile -> pop)
	for n : 0 .. i - 1
	    communityPile -> addCard (dealPile -> pop)
	end for
    end dealCommunity

    procedure call (n : int)
	for i : 0 .. 3
	    if players (n) -> playerBet < players (i) -> playerBet then
		if players (n) -> points >= players (i) -> playerBet - players (n) -> playerBet then
		    players (n) -> bet (players (i) -> playerBet - players (n) -> playerBet)
		else
		    players (n) -> bet (players (n) -> points)
		end if
	    end if
	end for
	players (n) -> call
    end call

    procedure raise (n, a : int)
	call (n)
	if players (n) -> points > a then
	    players (n) -> bet (a)
	end if
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

    function endRound : boolean
	var foldNum := 0
	for i : 0 .. 3
	    if players (i) -> folded or players (i) -> called or players (i) -> points = 0 then
		foldNum += 1
	    end if
	end for
	if foldNum = 4 then
	    for i : 0 .. 3
		players (i) -> uncall
	    end for
	    for i : 0 .. 3
		pot += players (i) -> playerBet
		players (i) -> clearBet
	    end for
	    result true
	end if
	result false
    end endRound

    procedure clearPot
	pot := 0
    end clearPot

    function checkWin : array 0 .. 3 of boolean
	% Check using bf : all possible pokerHands : all possible hands
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
	var pos : int

	% For every Player
	for i : 0 .. 3

	    % Make sure player has not folded
	    if players (i) -> folded = false then

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


		% ############# StraightFlush Check ##############

		% Flag to see if set found matching requirements
		flag := true

		% Go through the cards and look for flush first
		for h : 0 .. 6
		    suitCount (allCards (h) -> suit) += 1
		end for

		% Array for storing cards matching condition
		var sfArray : array 0 .. 4 of ^card

		% Take the cards that have the same suit
		for suit : 1 .. 4
		    % Check to see if there are five or more cards with the same suit
		    if suitCount (suit) >= 5 then
			% Iterate through all the cards
			for h : 0 .. 6
			    % If the card is the right suit take it
			    if allCards (h) -> suit = suit then
				% Increase the size of the check array
				new pokerHandCheck, upper (pokerHandCheck) + 1
				pokerHandCheck (upper (pokerHandCheck)) := allCards (h)
				% If there is an ace add a low version of ace
				if allCards (h) -> value = 14 then
				    var lowAce : ^card
				    new card, lowAce
				    lowAce -> setValues (1, allCards (h) -> suit)
				    new pokerHandCheck, upper (pokerHandCheck) + 1
				    pokerHandCheck (upper (pokerHandCheck)) := lowAce
				end if
			    end if
			end for
			flag := true
			exit
		    else
			% Flag saves checking time
			flag := false
		    end if
		end for

		% Check for a straight
		if flag then
		    % Sort the cards
		    sort (pokerHandCheck)
		    % Assume that there is no straight
		    flag := false
		    count := 0
		    % Start from the highest card
		    for decreasing h : upper (pokerHandCheck) .. 1
			% Check if the card next to it is one less
			if pokerHandCheck (h) -> value - pokerHandCheck (h - 1) -> value = 1 then
			    sfArray (count) := pokerHandCheck (h)
			    count += 1
			    % If card is same value then continue
			elsif pokerHandCheck (h) -> value - pokerHandCheck (h - 1) -> value = 0 then
			    % Else reset the counter
			else
			    count := 0
			end if

			% If five consecutive cards are found change flag
			if count = 4 then
			    sfArray (4) := pokerHandCheck (h - 1)
			    flag := true
			    exit
			end if
		    end for
		end if

		% Check to see if it is the highest straight flush

		if flag then
		    var sf : ^straightFlush
		    new straightFlush, sf

		    sf -> setCards (sfArray)
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

		% ############# End SF Check ##############



		% ############# Quad Check ##############

		% Check for quad
		count := 0
		previousValue := -1
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

		% If there is a quad check to see if it is the biggest
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
			    new playerInt, upper (playerInt) + 1
			    playerInt (upper (playerInt)) := i
			end if
		    else
			setValues := true
			highestPH := q
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    end if
		end if


		% ############## End Quad Check ##############



		% ############## Fullhouse Check ##############

		% Reset Flag variable
		flag := false

		% Check for Tripples
		count := 0
		previousValue := -1
		for decreasing h : 6 .. 0
		    if allCards (h) -> value = previousValue then
			count += 1
		    else
			previousValue := allCards (h) -> value
			count := 1
		    end if

		    if count = 3 then
			startIndex := h
			flag := true
			exit
		    end if
		end for

		% Check for Doubles
		count := 0
		previousValue := -1
		for decreasing h : 6 .. 0
		    if not flag then
			exit
		    elsif allCards (h) -> value = previousValue and allCards (h) -> value not= allCards (startIndex) -> value then
			count += 1
		    else
			previousValue := allCards (h) -> value
			count := 1
		    end if

		    if count = 2 then
			var fh : ^fullHouse
			var fhArray : array 0 .. 4 of ^card
			new fullHouse, fh
			new pokerHandCheck, 5

			for j : 0 .. 2
			    fhArray (j) := allCards (startIndex + j)
			end for

			for j : 0 .. 1
			    fhArray (3 + j) := allCards (h + j)
			end for

			fh -> setCards (fhArray)

			% Check to see if full house is biggest combo
			if setValues then
			    if fh -> compare (highestPH) = 1 then
				highestPH := fh
				highestHand := players (i) -> cards
				new playerInt, 0
				playerInt (0) := i
			    elsif fh -> compare (highestPH) = 0 then
				new playerInt, upper (playerInt) + 1
				playerInt (upper (playerInt)) := i
			    end if
			else
			    setValues := true
			    highestPH := fh
			    highestHand := players (i) -> cards
			    new playerInt, 0
			    playerInt (0) := i
			end if
			exit
		    end if
		end for

		% ############## End Fullhouse Check ##############


		% ############## Check For Flush ##############

		% Check for flush
		for suit : 1 .. 4
		    % Check to see if there are five or more cards with the same suit
		    if suitCount (suit) >= 5 then
			% Iterate through all the cards
			for decreasing h : 6 .. 0
			    % If the card is the right suit take it
			    if allCards (h) -> suit = suit then
				% Increase the size of the check array
				new pokerHandCheck, upper (pokerHandCheck) + 1
				pokerHandCheck (upper (pokerHandCheck)) := allCards (h)
			    end if

			    if upper (pokerHandCheck) = 4 then
				% Set values of cards
				var f : ^flush
				var fArray : array 0 .. 4 of ^card
				new flush, f
				for j : 0 .. 4
				    fArray (j) := pokerHandCheck (j)
				end for
				f -> setCards (fArray)

				if setValues then
				    if f -> compare (highestPH) = 1 then
					highestPH := f
					highestHand := players (i) -> cards
					new playerInt, 0
					playerInt (0) := i
				    elsif f -> compare (highestPH) = 0 then
					new playerInt, upper (playerInt) + 1
					playerInt (upper (playerInt)) := i
				    end if
				else
				    setValues := true
				    highestPH := f
				    highestHand := players (i) -> cards
				    new playerInt, 0
				    playerInt (0) := i
				end if
				exit
			    end if
			end for
		    end if
		end for

		% ############## End Check for Flush ##############


		% ############## Check for Straight ##############

		% Variables for checking
		flag := false
		var sArray : array 0 .. 4 of ^card

		% Start from the highest card
		for decreasing h : upper (pokerHandCheck) .. 1
		    % Check if the card next to it is one less
		    
		    if pokerHandCheck (h) -> value = -1 then
		    elsif pokerHandCheck (h - 1) -> value = -1 then
		    end if
		    
		    if pokerHandCheck (h) -> value - pokerHandCheck (h - 1) -> value = 1 then
			sArray (count) := pokerHandCheck (h)
			count += 1
			% If card is same value then continue
		    elsif pokerHandCheck (h) -> value - pokerHandCheck (h - 1) -> value = 0 then
			% Else reset the counter
		    else
			count := 0
		    end if

		    % If five consecutive cards are found change flag
		    if count = 4 then
			startIndex := h
			sArray (4) := pokerHandCheck (h - 1)
			flag := true
			exit
		    end if
		end for

		% If five consecutive cards are found change flag
		if count = 4 then
		    var s : ^straight
		    new straight, s

		    s -> setCards (sArray)

		    if setValues then
			if s -> compare (highestPH) = 1 then
			    highestPH := s
			    highestHand := players (i) -> cards
			    new playerInt, 0
			    playerInt (0) := i
			elsif s -> compare (highestPH) = 0 then
			    new playerInt, upper (playerInt) + 1
			    playerInt (upper (playerInt)) := i
			end if
		    else
			setValues := true
			highestPH := s
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    end if
		    exit
		end if
		% ############## End Check for Straight ##############


		% ############## Check for triple ##############

		% Check for tripple
		count := 0
		previousValue := -1
		for h : 0 .. 6
		    if allCards (h) -> value = previousValue then
			count += 1
		    else
			previousValue := allCards (h) -> value
			count := 1
		    end if

		    if count = 3 then
			startIndex := h
			exit
		    end if
		end for

		% If there is a tripple check to see if it is the biggest
		if count = 3 then
		    var t : ^triple
		    new triple, t
		    var tArray : array 0 .. 2 of ^card
		    for h : 0 .. 2
			tArray (h) := allCards (startIndex - h)
		    end for
		    t -> setCards (tArray)
		    if setValues then
			if t -> compare (highestPH) = 1 then
			    highestPH := t
			    highestHand := players (i) -> cards
			    new playerInt, 0
			    playerInt (0) := i
			elsif t -> compare (highestPH) = 0 then
			    new playerInt, upper (playerInt) + 1
			    playerInt (upper (playerInt)) := i
			end if
		    else
			setValues := true
			highestPH := t
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    end if
		end if
		% ############## End Check for triple ##############


		% ############## Check for Pair ##############

		% Check for pair
		count := 0
		previousValue := -1
		for h : 0 .. 6
		    if allCards (h) -> value = previousValue then
			count += 1
		    else
			previousValue := allCards (h) -> value
			count := 1
		    end if

		    if count = 2 then
			startIndex := h
			exit
		    end if
		end for

		% If there is a double check to see if it is the biggest
		if count = 2 then
		    var p : ^pair
		    new pair, p
		    var pArray : array 0 .. 1 of ^card
		    for h : 0 .. 1
			pArray (h) := allCards (startIndex - h)
		    end for
		    p -> setCards (pArray)
		    if setValues then
			if p -> compare (highestPH) = 1 then
			    highestPH := p
			    highestHand := players (i) -> cards
			    new playerInt, 0
			    playerInt (0) := i
			elsif p -> compare (highestPH) = 0 then
			    new playerInt, upper (playerInt) + 1
			    playerInt (upper (playerInt)) := i
			end if
		    else
			setValues := true
			highestPH := p
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    end if
		end if
		% ############## End Check for Pair ##############

		% ############## Check for Single ##############
		var s : ^single
		new single, s
		var siArray : array 0 .. 4 of ^card
		for decreasing h : 6 .. 2
		    siArray (h - 2) := allCards (h)
		end for
		s -> setCards (siArray)

		if setValues then
		    if s -> compare (highestPH) = 1 then
			highestPH := s
			highestHand := players (i) -> cards
			new playerInt, 0
			playerInt (0) := i
		    elsif s -> compare (highestPH) = 0 then
			new pokerHandCheck, 6
			communityPile -> getCards (pokerHandCheck)
			highestHand -> getCards (playerHand)

			var siCompare : array 0 .. 4 of ^card
			var cpCount : int := 0
			var hhCount : int := 0

			for h : 0 .. 4
			    if cpCount > 6 then
				siCompare (h) := playerHand (hhCount)
				hhCount += 1
			    elsif hhCount > 1 then
				siCompare (h) := pokerHandCheck (cpCount)
				cpCount += 1
			    elsif pokerHandCheck (cpCount) -> compare (playerHand (hhCount)) = 1 then
				siCompare (h) := pokerHandCheck (cpCount)
				cpCount += 1
			    else
				siCompare (h) := playerHand (hhCount)
				hhCount += 1
			    end if
			end for

			flag := false

			for h : 0 .. 4
			    if siArray (h) -> compare (siCompare (h)) = 1 then
				highestPH := s
				highestHand := players (i) -> cards
				new playerInt, 0
				playerInt (0) := i
				flag := true
				exit
			    elsif siArray (h) -> compare (siCompare (h)) = -1 then
				flag := true
				exit
			    end if
			end for
			if not flag then
			    new playerInt, upper (playerInt) + 1
			    playerInt (upper (playerInt)) := i
			end if

		    end if
		else
		    setValues := true
		    highestPH := s
		    highestHand := players (i) -> cards
		    new playerInt, 0
		    playerInt (0) := i
		end if
		% ############## End Check for Single ##############
	    end if

	end for

	var booleanWin : array 0 .. 3 of boolean
	for i : 0 .. 3
	    booleanWin (i) := false
	end for
	for i : 0 .. upper (playerInt)
	    booleanWin (playerInt (i)) := true
	end for

	result booleanWin

    end checkWin

end game
