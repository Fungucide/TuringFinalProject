% CardClass.t
% Dec 15, 2016
% William Fung
% card and deck classes

% Updates
% -----------------------
% Dec 22, 2016
% - created
% - skeleton game created

include "GameClass.t"
var testGame : ^game
new game, testGame

var see : array 0..1 of ^card 

var cards : array 0 .. 51 of ^card

for i : 0 .. 51
    new card, cards (i)
    cards (i) -> setValues (i mod 13 + 1, i div 13 + 1)
end for
testGame -> initialize (cards)
% testGame -> dealPile -> listAll
testGame -> dealPlayer
testGame -> players(0)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)
put("")

testGame -> players(1)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)
put("")

testGame -> players(2)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)
put("")

testGame -> players(3)->cards->getCards(see)
put(see(0)->value)
put(see(0)->suit)
put(see(1)->value)
put(see(1)->suit)

testGame->dealCommunity(3)
