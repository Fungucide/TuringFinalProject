% PokerHands.t
% Dec 5, 2016
% William Fung
% Poker Hands

% Updates
% ---------------------
% Dec 15, 2016
% - Initial Creation of file
% ---------------------
% Dec 17, 2016
% -Added all pokerhands

% NOTE: Need to be careful for high or low ace

include "CardClass.t"

class pokerHand

    import card, sort
    export (highCard, score, compare)
    var highCard : ^card
    var score : int := -1

    function compare (ph : ^pokerHand) : int
	if score > ph -> score then
	    result 1
	elsif score < ph -> score then
	    result - 1
	else
	    result highCard -> compare (ph -> highCard)
	end if
    end compare

end pokerHand

class pair
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 1 of ^card
    score := 1

    function isValid (c : array 0 .. 1 of ^card) : boolean
	if c (0) -> compare (c (1)) = 0 then
	    result true
	else
	    result false
	end if
    end isValid

    procedure setCards (c : array 0 .. 1 of ^card)
	cards (0) := c (0)
	cards (1) := c (1)
	var valid : boolean
	var highCard := cards (0)
	if not isValid (cards) then
	    put "ERROR -> pair -> setCards"
	    cards (0) := nil
	    cards (1) := nil
	end if
    end setCards
end pair

class twoPair
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 3 of ^card
    score := 2

    function isValid (c : array 0 .. 3 of ^card) : boolean
	var matchFirst : int := -1
	for i : 1 .. 3
	    if c (0) -> compare (c (i)) = 0 then
		matchFirst := i
		exit
	    end if
	end for

	if matchFirst = -1 then
	    result false
	end if
	if matchFirst = 1 then
	    if c (2) -> compare (c (3)) not= 0 then
		result false
	    end if
	elsif matchFirst = 2 then
	    if c (1) -> compare (c (3)) not= 0 then
		result false
	    end if
	else
	    if c (1) -> compare (c (2)) not= 0 then
		result false
	    end if
	end if
	result true
    end isValid

    procedure setCards (c : array 0 .. 3 of ^card)
	cards (0) := c (0)
	cards (1) := c (1)
	cards (2) := c (2)
	cards (3) := c (3)
	var highCard := cards (0)
	if not isValid (cards) then
	    put "ERROR -> triple -> setCards"
	    cards (0) := nil
	    cards (1) := nil
	    cards (2) := nil
	end if
    end setCards

end twoPair

class triple
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 2 of ^card
    score := 3

    function isValid (c : array 0 .. 2 of ^card) : boolean
	if c (0) -> compare (c (1)) = 0 and c (1) -> compare (c (2)) = 0 then
	    result true
	else
	    result false
	end if
    end isValid

    procedure setCards (c : array 0 .. 2 of ^card)
	cards (0) := c (0)
	cards (1) := c (1)
	cards (2) := c (2)
	var highCard := cards (0)

	if not isValid (cards) then
	    put "ERROR -> triple -> setCards"
	    cards (0) := nil
	    cards (1) := nil
	    cards (2) := nil
	end if
    end setCards
end triple

class straight
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 4 of ^card
    score := 4

    function isValid (c : array 0 .. 4 of ^card) : boolean
	for i : 0 .. 3
	    if c (i + 1) -> value - c (i) -> value not= 1 then
		result false
	    end if
	end for
	result true
    end isValid

    procedure setCards (c : array 0 .. 4 of ^card)
	var temp := c
	sort (temp)
	highCard := temp (4)
	for i : 0 .. 4
	    cards (i) := temp (i)
	end for

	if not isValid (cards) then
	    put "ERROR -> straight -> setCards"
	    for i : 0 .. 4
		cards (i) := nil
	    end for
	end if
    end setCards
end straight

class flush
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 4 of ^card
    score := 5

    function isValid (c : array 0 .. 4 of ^card) : boolean
	for i : 1 .. 4
	    if c (0) -> suit not= c (i) -> suit then
		result false
	    end if
	end for
	result true
    end isValid

    procedure setCards (c : array 0 .. 4 of ^card)
	highCard := c (0)
	for i : 0 .. 4
	    cards (i) := c (i)
	    if highCard -> compare (c (i)) = -1 then
		highCard := c (i)
	    end if
	end for

	if not isValid (cards) then
	    put "ERROR -> flush -> setCards"
	    for i : 0 .. 4
		cards (i) := nil
	    end for
	end if
    end setCards
end flush

class fullHouse
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 4 of ^card
    score := 6

    function isValid (c : array 0 .. 4 of ^card) : boolean
	if c (0) -> compare (c (1)) = 0 and c (3) -> compare (c (4)) = 0 and (c (2) -> compare (c (0)) = 0 or c (2) -> compare (c (4)) = 0) then
	    result true
	else
	    result false
	end if
    end isValid

    procedure setCards (c : array 0 .. 4 of ^card)
	var temp := c
	sort (temp)
	highCard := temp (2)
	for i : 0 .. 4
	    cards (i) := temp (i)
	end for

	if not isValid (cards) then
	    put "ERROR -> fullHouse -> setCards"
	    for i : 0 .. 4
		cards (i) := nil
	    end for
	end if
    end setCards
end fullHouse

class quad
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 3 of ^card
    score := 7

    function isValid (c : array 0 .. 3 of ^card) : boolean
	for i : 1 .. 3
	    if c (0) -> compare (c (i)) not= 0 then
		result false
	    end if
	end for
	result true
    end isValid

    procedure setCards (c : array 0 .. 3 of ^card)
	highCard := c (0)
	for i : 0 .. 3
	    cards (i) := c (i)
	end for

	if not isValid (cards) then
	    put "ERROR -> quad -> setCards"
	    for i : 0 .. 3
		cards (i) := nil
	    end for
	end if
    end setCards
end quad

class straightFlush
    inherit pokerHand
    export (setCards, isValid)

    var cards : array 0 .. 4 of ^card
    score := 8

    function isValid (c : array 0 .. 4 of ^card) : boolean
	for i : 0 .. 3
	    if c (i + 1) -> value - c (i) -> value not= 1 and c (0) -> suit = c (i) -> suit then
		result false
	    end if
	end for
	result true
    end isValid

    procedure setCards (c : array 0 .. 4 of ^card)
	var temp := c
	sort (temp)
	highCard := temp (4)
	for i : 0 .. 4
	    cards (i) := temp (i)
	end for

	if not isValid (cards) then
	    put "ERROR -> straightFlush -> setCards"
	    for i : 0 .. 4
		cards (i) := nil
	    end for
	end if
    end setCards
end straightFlush
