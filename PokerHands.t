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
    var highCard : ^card
    var score : int := -1
    var cards : flexible array 0 .. 0 of ^cards

    procedure isValid (var r : boolean)

    end isValid

    procedure setCards (c : array 0 .. * of ^cards)

    end setCards

    procedure compare (ph : ^pokerHand, var r : int)
        if score > ph -> score then
            r := 1
        elsif score < ph -> score then
            r := -1
        else
            r := 0
        end if
    end compare

end pokerHand

class pair
    inherit pokerHand

    socre := 1

    procedure isValid (c : array 0 .. 1 of ^cards, var r : boolean)
        if cards (0) -> compare (cards (1)) = 0 then
            r := true
        else
            r := false
        end if
    end isValid

    procedure setCards (c : array 0 .. 1 of ^cards)
        new cards, 1
        cards (0) := c (0)
        cards (1) := c (1)
        var valid : boolean
        var highCard := cards (0)
        isValid (cards, valid)
        if not valid then
            put "ERROR -> pair -> setCards"
            cards (0) = nil
            cards (1) = nil
        end if
    end setCards
end pair

class triple
    inherit pokerHand

    score := 2

    procedure isValid (c : array 0 .. 4 of ^cards, var r : boolean)
    end is
    Valid

end triple
