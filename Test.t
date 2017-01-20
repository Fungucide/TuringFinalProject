include "CardClass.t"
include "PokerHands.t"

% ####################### PREINCLUDED #####################
var highestPH : ^pokerHand
var highestHand : ^hand
var playerInt : flexible array 0 .. -1 of int
var setValues := false
var flag := true

new pokerHand, highestPH
new hand, highestHand

% General Arrays for storing cards
var pokerHandCheck : flexible array 0 .. -1 of ^card
var playerHand : array 0 .. 1 of ^card

% Variables for checking straightFlush or flush
var suitCount : array 1 .. 4 of int := init (0, 0, 0, 0)
var count : int := 0
var startIndex : int := -1
var previousValue := -1
var pos : int



var allCards : array 0 .. 6 of ^card
for i : 0 .. 6
    new card, allCards (i)
end for
allCards (0) -> setValues (6, 3)
allCards (1) -> setValues (8, 3)
allCards (2) -> setValues (6, 2)
allCards (3) -> setValues (6, 3)
allCards (4) -> setValues (6, 3)
allCards (5) -> setValues (13, 1)
allCards (6) -> setValues (6, 3)

sort (allCards)


% ##############################

% ##############################


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
		% put "True"
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
