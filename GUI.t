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
winID := Window.Open ("position:0;200,graphics:1280;680") 
var font1 : int

View.Set ("offscreeenonly")

function getCardImage (int suit,value)
var imgName := value + suit + ".png"

end getCardImage

%player hand
drawfillbox (525,20,625,170,black)
drawfillbox (775,20,675,170,black)
%top hand
drawfillbox (525,510,625,660,black)
drawfillbox (775,510,675,660,black)
%left hand
drawfillbox (20,325,170,225,black)
drawfillbox (20,375,170,475,black)
%right hand
drawfillbox (1110,325,1260,225,black)
drawfillbox (1110,375,1260,475,black)
%middle cards
drawfillbox (360,230,460,380,black)
drawfillbox (480,230,580,380,black)
drawfillbox (600,230,700,380,black)
drawfillbox (720,230,820,380,black)
drawfillbox (840,230,940,380,black)
%points
font1 := Font.New ("serif:20")
Font.Draw("Points: xxxx",580,180,font1,black)
Font.Draw("Points: xxxx",580,480,font1,black)
Font.Draw("Points: xxxx",30,490,font1,black)
Font.Draw("Points: xxxx",1120,490,font1,black)
%pot and current bet
Font.Draw("Pot: xxxxx",480,400,font1,black)
Font.Draw("Current bet: xxxx",680,400,font1,black)
