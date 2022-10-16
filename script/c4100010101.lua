--A Card Entruster
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.PreStart(c,nil,s.flipop,1)
	--DuelLinks.Predraw(c,nil,s.flipop,1)
	DuelLinks.Ignition(c,nil,s.flipop,1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local tc=Duel.CreateToken(tp,24874630)
	Duel.SendtoDeck(tc,tp,2,REASON_RULE)
end