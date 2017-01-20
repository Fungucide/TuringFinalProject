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

