--Random Deck
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	Xyz.AddProcedure(c,nil,4,2)
	Pendulum.AddProcedure(c,false)
	--skill
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Duel.SetLP(tp,Duel.AnnounceNumber(tp,8000,16000,4000,2000,1000))
	local startlp=Duel.GetLP(tp)
	--Delete Your Cards
	s.DeleteDeck(tp)
	--Choose 1 of 2 Options
	local sel={}
	table.insert(sel,aux.Stringid(id,1))
	table.insert(sel,aux.Stringid(id,2))
	local selop=Duel.SelectOption(tp,false,table.unpack(sel))
	if selop==0 then
		--Get Random Deck
		s.RandomDeck(tp)
	else
		--Choose 1 of the Decks
		s.ChooseDeck(tp)
	end
	--Add Relay Mode
	s.RelayDeck(tp,startlp,selop)
	--Duel.TagSwap(1-tp)
end
function s.DeleteDeck(p)
	local del=Duel.GetFieldGroup(p,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
	--Duel.RemoveCards(del,tp,-2,REASON_RULE)
end
function s.RandomDeck(tp)
	--Get Random Deck
	local decknum=Duel.GetRandomNumber(1,#s.DeckList)
	local deckid=s.DeckList[decknum][1]
	--Add Random Deck
	local deck=s.DeckList[decknum][2]
	local extra=s.DeckList[decknum][3]
	for _,v in ipairs(extra) do table.insert(deck,v) end
	for code,code2 in ipairs(deck) do
		--Debug.AddCard(code2,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
		local tc=Duel.CreateToken(tp,code2)
		--tc:Cover(deckid)
		Duel.SendtoDeck(tc,tp,1,REASON_RULE)
	end
	--Debug.ReloadFieldEnd()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
	--Duel.ShuffleExtra(tp)
end
function s.ChooseDeck(tp)
	--Choose 1 of the Deck
	local decklist={}
	for i=1,#s.DeckList do
		table.insert(decklist,s.DeckList[i][1])
	end
	local deckid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(decklist))
	local decknum=deckid-id-100
	--Add Random Deck
	local deck=s.DeckList[decknum][2]
	local extra=s.DeckList[decknum][3]
	for _,v in ipairs(extra) do table.insert(deck,v) end
	Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(deck))
	for code,code2 in ipairs(deck) do
		--Debug.AddCard(code2,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
		local tc=Duel.CreateToken(tp,code2)
		tc:Cover(deckid)
		Duel.SendtoDeck(tc,tp,1,REASON_RULE)
	end
	Duel.ShuffleDeck(tp)
	--Debug.ReloadFieldEnd()
	--Duel.ShuffleExtra(tp)
end










function s.RelayDeck(tp,startlp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(s.RelayOp(startlp))
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DAMAGE)
	Duel.RegisterEffect(e3,tp)
end
function s.RelayOp(startlp,selop)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.GetLP(tp)<=1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					--Delete Your Cards
					s.DeleteDeck(tp)
					if selop==0 then
						--Get Random Deck
						s.RandomDeck(tp)
					else
						--Choose 1 of the Decks
						s.ChooseDeck(tp)
					end
					Duel.SetLP(tp,startlp)
					Duel.Draw(tp,5,REASON_RULE)
					if Duel.GetTurnPlayer()~=tp then
						Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
						Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					end
				end
			end
end









s.DeckList={}



	--Albuz Dogmatik
	s.DeckList[1]={}
	--Deck ID
	s.DeckList[1][1]=id+100+1
	--Main Deck
	s.DeckList[1][2]={22073844,69680031,69680031,69680031,13694209,95679145,68468459,68468459,45484331,45484331,45484331,55273560,55273560,60303688,60303688,60303688,14558127,14558127,14558127,40352445,40352445,48654323,48654323,1984618,1984618,1984618,34995106,44362883,31002402,31002402,60921537,24224830,65589010,10045474,10045474,10045474,29354228,82956214,82956214,82956214}
	--Extra Deck
	s.DeckList[1][3]={44146295,44146295,34848821,41373230,41373230,41373230,87746184,87746184,80532587,80532587,80532587,79606837,79606837,79606837,70369116}

	--Albuz Springans
	s.DeckList[2]={}
	--Deck ID
	s.DeckList[2][1]=id+100+2
	--Main Deck
	s.DeckList[2][2]={29601381,29601381,29601381,83203672,83203672,20424878,20424878,68468459,68468459,45484331,45484331,45484331,67436768,67436768,56818977,14558127,14558127,14558127,23499963,23499963,23499963,101111054,101111054,101111054,70485614,44362883,73628505,29948294,29948294,29948294,7496001,7496001,7496001,60884672,60884672,60884672,25415161,25415161,25415161,17751597}
	--Extra Deck
	s.DeckList[2][3]={44146295,44146295,70534340,101111045,101111045,1906812,1906812,41373230,87746184,90448279,62941499,62941499,48285768,48285768,70369116}

	--Albuz Swordsoul
	s.DeckList[3]={}
	--Deck ID
	s.DeckList[3][1]=id+100+3
	--Main Deck
	s.DeckList[3][2]={25451383,93490856,93490856,93490856,56495147,56495147,56495147,82489470,82489470,68468459,68468459,20001443,20001443,20001443,45484331,45484331,45484331,55273560,55273560,14558127,14558127,14558127,34995106,44362883,56465981,56465981,56465981,93850690,93850690,93850690,10045474,10045474,10045474,14821890,14821890,14821890,99137266,17751597,17751597,17751597}
	--Extra Deck
	s.DeckList[3][3]={44146295,44146295,70534340,87746184,96633955,96633955,84815190,47710198,47710198,92519087,9464441,69248256,69248256,69248256,70369116}

	--Albuz Tri-Brigade
	s.DeckList[4]={}
	--Deck ID
	s.DeckList[4][1]=id+100+4
	--Main Deck
	s.DeckList[4][2]={25451383,87209160,87209160,87209160,68468459,68468459,45484331,45484331,45484331,55273560,55273560,19096726,19096726,19096726,14558127,14558127,14558127,50810455,50810455,50810455,56196385,56196385,14816857,14816857,14816857,34995106,44362883,24224830,29948294,29948294,29948294,51097887,51097887,51097887,10045474,10045474,10045474,40975243,40975243,40975243}
	--Extra Deck
	s.DeckList[4][3]={44146295,44146295,34848821,34848821,34848821,87746184,99726621,99726621,4280259,52331012,52331012,47163170,47163170,26847978,70369116}

	--Marincess
	s.DeckList[5]={}
	--Deck ID
	s.DeckList[5][1]=id+100+5
	--Main Deck
	s.DeckList[5][2]={57541158,57541158,57541158,91953000,91953000,91953000,99885917,99885917,99885917,21057444,21057444,21057444,31059809,31059809,31059809,36492575,36492575,36492575,60643554,60643554,60643554,28174796,57160136,57160136,57160136,57329501,57329501,57329501,83764718,24224830,91027843,91027843,91027843,10045474,10045474,10045474,52945066,52945066,52945066,23002292}
	--Extra Deck
	s.DeckList[5][3]={67557908,94942656,94942656,47910940,94207108,20934852,84546257,79130389,79130389,59859086,67712104,67712104,43735670,43735670,30691817}

	--Evil Twin Phoenix Eforcer
	s.DeckList[6]={}
	--Deck ID
	s.DeckList[6][1]=id+100+6
	--Main Deck
	s.DeckList[6][2]={81866673,63362460,14558127,14558127,14558127,36326160,36326160,36326160,54257392,54257392,73810864,73810864,73810864,81078880,81078880,73642296,73642296,73642296,25311006,25311006,25311006,52947044,52947044,52947044,57160136,57160136,57160136,61976639,61976639,61976639,8083925,8083925,8083925,24224830,37582948,37582948,37582948,10045474,10045474,10045474}
	--Extra Deck
	s.DeckList[6][3]={60461804,90448279,36776089,98127546,93672138,93672138,93672138,21887175,86066372,9205573,9205573,9205573,36609518,36609518,36609518}

	--Naphil Asylum Chaos Knight
	s.DeckList[7]={}
	--Deck ID
	s.DeckList[7][1]=id+100+7
	--Main Deck
	s.DeckList[7][2]={61496006,61496006,61496006,98881700,98881700,98881700,7150545,7150545,7150545,70156946,70156946,70156946,31059809,31059809,31059809,14558128,14558128,14558128,6625096,6625096,6625096,19885332,19885332,19885332,23153227,23153227,23153227,57734012,83764718,97769122,97769122,97769122,30761649,10045474,10045474,10045474,847915,68630939,68630939,68630939}
	--Extra Deck
	s.DeckList[7][3]={99469936,61374414,61374414,20785975,12744567,34876719,34876719,440556,37279508,94380860,48739166,67557908,94942656,94942656,90809975}

	--Umi Fisherman
	s.DeckList[8]={}
	--Deck ID
	s.DeckList[8][1]=id+100+8
	--Main Deck
	s.DeckList[8][2]={11012154,96546575,44968687,19801646,19801646,23931679,23931679,23931679,95824983,95824983,95824983,69436288,31059809,31059809,31059809,57511992,14558128,14558128,14558128,22819092,22819092,22819092,63854005,63854005,63854005,58203736,58203736,295517,295517,295517,10045474,10045474,10045474,53582587,53582587,53582587,95602345,95602345,95602345,19089195}
	--Extra Deck
	s.DeckList[8][3]={96334243,96334243,96633955,9464441,42566602,39964797,440556,67557908,67557908,94942656,94942656,94942656,90809975,79130389,79130389}

	--Number 39 Hope
	s.DeckList[9]={}
	--Deck ID
	s.DeckList[9][1]=id+100+9
	--Main Deck
	s.DeckList[9][2]={29353756,81471108,45082499,32164201,23720856,23720856,23720856,8512558,8512558,8512558,40941889,4647954,4647954,4647954,68258355,68258355,68258355,59724555,59724555,59724555,64591429,64591429,64591429,4017398,4017398,4017398,35906693,36224040,36224040,48333324,62623659,62623659,62623659,67517351,67517351,94770493,95856586,68630939,68630939,68630939}
	--Extra Deck
	s.DeckList[9][3]={95134948,95134948,51543904,21521304,2896663,66970002,56832966,68679595,68679595,56840427,84013237,84013238,84013239,31123642,62517849}

	--Exorsister Utopia
	s.DeckList[10]={}
	--Deck ID
	s.DeckList[10][1]=id+100+10
	--Main Deck
	s.DeckList[10][2]={101109025,101109025,101109025,40894584,44680819,60666820,62953041,4647954,4647954,4647954,16474916,16474916,16474916,43863925,43863925,43863925,5352328,5352328,73642296,73642296,73642296,67517351,83764718,4408198,4408198,4408198,24224830,77913594,77913594,77913594,30802207,10045474,10045474,10045474,77891946,77891946,77891946,101109076,101109076,101109076}
	--Extra Deck
	s.DeckList[10][3]={95134948,59242457,2896663,68679595,84013238,84013238,42741437,42741437,42741437,78135071,78135071,41524885,5530780,26973555,65305468}

	--Melodius
	s.DeckList[11]={}
	--Deck ID
	s.DeckList[11][1]=id+100+11
	--Main Deck
	s.DeckList[11][2]={3395226,79514956,40502912,40502912,40502912,16021142,16021142,16021142,62895219,62895219,37742478,37742478,44656450,44656450,76990617,76990617,76990617,14558127,14558127,14558127,41767843,41767843,5288597,9113513,9113513,9113513,24094653,44256816,44256816,44256816,83764718,24224830,24299458,100287035,100287035,100287035,10045474,10045474,10045474,59919307}
	--Extra Deck
	s.DeckList[11][3]={24672164,24672164,57594700,57594700,57594700,84988419,84988419,90590303,46772449,86066372,38342335,2857636,75452921,34974462,34974462}

	--Lunalight
	s.DeckList[12]={}
	--Deck ID
	s.DeckList[12][1]=id+100+12
	--Main Deck
	s.DeckList[12][2]={47705572,47705572,20292186,94919024,11439455,35618217,35618217,35618217,14152693,14152693,50546208,50546208,48427163,14558127,14558127,14558127,11317977,11317977,1475311,1475311,24094653,35726888,35726888,35726888,48444114,48444114,48444114,81439173,83764718,87931906,87931906,87931906,57103969,100287035,100287035,100287035,10045474,10045474,10045474,13935001}
	--Extra Deck
	s.DeckList[12][3]={24550676,24550676,88753594,88753594,97165977,97165977,51777272,51777272,55285840,96381979,6983839,90590303,46772449,7480763,70369116}

	--Windwitch
	s.DeckList[13]={}
	--Deck ID
	s.DeckList[13][1]=id+100+13
	--Main Deck
	s.DeckList[13][2]={86395581,86395581,86395581,84851250,84851250,84851250,71007216,71007216,71007216,20246864,20246864,20246864,43722862,43722862,43722862,14558128,14558128,14558128,52038441,52038441,52038441,70117860,70117860,70117860,97268402,11827244,11827244,76647978,96156729,96156729,96156729,100287035,100287035,100287035,10045474,10045474,10045474,19362568,19362568,19362568}
	--Extra Deck
	s.DeckList[13][3]={84433295,25793414,25793414,84815190,50954680,50954680,73667937,73667937,82044279,14577226,14577226,14577226,98506199,35252119,91336701}

	--Lyrilusc
	s.DeckList[14]={}
	--Deck ID
	s.DeckList[14][1]=id+100+14
	--Main Deck
	s.DeckList[14][2]={14558127,14558127,14558127,46576366,46576366,97949165,97949165,97949165,60954556,60954556,60954556,10182251,10182251,10182251,34550857,34550857,34550857,97268402,24094653,35261759,35261759,35261759,45354718,45354718,45354718,51405049,51405049,51405049,81439174,24224830,72859417,100287035,100287035,100287035,8243121,8243121,10045474,10045474,10045474,87639778}
	--Extra Deck
	s.DeckList[14][3]={76815942,90448279,90448279,26973555,8491961,8491961,8491961,19369609,48608796,48608796,65305468,72971064,72971064,41999284,94259633}

	--Synchro Mayakashi Zombie
	s.DeckList[15]={}
	--Deck ID
	s.DeckList[15][1]=id+100+15
	--Main Deck
	s.DeckList[15][2]={101108014,39185163,36016907,6039967,66570171,66570171,52467217,52467217,92826944,92826944,92826944,94801854,94801854,49959355,49959355,49959355,14558127,14558127,14558127,42542842,42542842,101108013,41729254,41729254,41729254,92964816,2364438,2364438,2364438,35705817,101108060,4064256,4064256,4064256,4333086,4333086,4333086,39753577,91742238,62219643}
	--Extra Deck
	s.DeckList[15][3]={8198620,101108039,101108039,3486020,101108040,4103668,28240337,101108041,101108041,77092311,30607616,2645637,72860663,36114945,66870733}

	--Odd-Eyes Performapal Magician
	s.DeckList[16]={}
	--Deck ID
	s.DeckList[16][1]=id+100+16
	--Main Deck
	s.DeckList[16][2]={14105623,14105623,16306932,16306932,46136942,16178683,12289247,20292186,56677752,40318957,40318957,75672051,11067666,49684352,58092907,101108001,101108001,101108001,47075569,47075569,48461764,73941492,73941492,20409757,101108002,101108002,82224646,82661461,54941203,101108034,37469904,37469904,37469904,53208660,53208660,82768499,74850403,27813661,27813661,1344018}
	--Extra Deck
	s.DeckList[16][3]={49820233,53262004,84815190,70771599,80696379,98558751,16691074,42160203,47349116,4280258,45819647,7480763,50588353,101108048,101108048}

	--Stardust Dragon
	s.DeckList[17]={}
	--Deck ID
	s.DeckList[17][1]=id+100+17
	--Main Deck
	s.DeckList[17][2]={37799519,37799519,63184227,63184227,63977008,63977008,63977008,67692580,67692580,57458399,57458399,11069680,11069680,11069680,19642774,80457744,80457744,68543408,86784733,86784733,291414,291414,8487449,8487449,21159309,2295440,32807846,37750912,37750912,81439173,83764718,96363153,96363153,96363153,99243014,99243014,99243014,24224830,365213,98020526}
	--Extra Deck
	s.DeckList[17][3]={40939228,7841112,24696097,40139997,74892653,84664085,81020646,44508094,44508095,64880894,60800381,77075360,53325667,37675907,50091196}

	--Black Rose Dragon
	s.DeckList[18]={}
	--Deck ID
	s.DeckList[18][1]=id+100+18
	--Main Deck
	s.DeckList[18][2]={44928016,17720747,12213463,12213463,12213463,93708824,93708824,93708824,35272499,35272499,35272499,26118970,26118970,61677004,29177818,44125452,48686504,48686504,48686504,14558128,14558128,14558128,90724272,90724272,29107423,29107423,29107423,11747708,101108018,2295440,76647978,81439173,83764718,24224830,48130397,53503015,69167267,69167267,69167267,71645242}
	--Extra Deck
	s.DeckList[18][3]={79864860,41209828,101108037,84815190,40139997,92519087,27548199,33698022,73580472,53325667,76524506,49202162,50588353,72218246,70369116}

	--Shiranui Mayakashi
	s.DeckList[19]={}
	--Deck ID
	s.DeckList[19][1]=id+100+19
	--Main Deck
	s.DeckList[19][2]={39185163,36016907,66570171,52467217,52467217,92826944,92826944,92826944,41562624,41562624,99423156,62038047,94801854,94801854,94801854,49959355,49959355,49959355,99745551,79783880,43694650,14558127,14558127,14558127,73642296,73642296,36630403,92964816,75500286,81439173,19942835,24224830,4064256,4064256,4333086,4333086,4333086,62219643,62219643,62219643}
	--Extra Deck
	s.DeckList[19][3]={59843383,84815190,27548199,83283063,65187687,68431965,52711246,57288064,91575236,50091196,2645637,86926989,37129797,37129797,50588353}
