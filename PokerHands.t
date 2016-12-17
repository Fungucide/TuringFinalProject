% PokerHands.t
% Dec 5, 2016
% William Fung
% Poker Hands

% Updates
% ---------------------
% Dec 15, 2016
% - Initial Creation of file
% -

% To do
% ---------------------
% - Add all poker hands

include "CardClass.t"
class pokerHand

    import card
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

class flush
    inherit pokerHand

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
