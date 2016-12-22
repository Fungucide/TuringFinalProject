% PokerHands.t
% Dec 5, 2016
% William Fung
% Poker Hands

% Updates
% ---------------------
% Dec 21, 2016
% - figuring out position for all cards 
% ---------------------

var winID : int 
winID := Window.Open ("position:0;200,graphics:1300;700") 

View.Set ("offscreeenonly")

drawfillbox (525,20,625,170,black)
drawfillbox (775,20,675,170,black)

drawfillbox (525,530,625,680,black)
drawfillbox (775,530,675,680,black)

drawfillbox (20,325,170,225,black)
drawfillbox (20,375,170,475,black)

drawfillbox (1130,325,1280,225,black)
drawfillbox (1130,375,1280,475,black)

drawfillbox (360,270,460,420,black)
drawfillbox (480,270,580,420,black)
drawfillbox (600,270,700,420,black)
drawfillbox (720,270,820,420,black)
drawfillbox (840,270,940,420,black)

