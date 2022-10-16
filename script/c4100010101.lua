--A Card Entruster
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	--DuelLinks.AddProcedure(c)
	--DuelLinks.StartUp(c,nil,s.flipop,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local tc=Duel.CreateToken(tp,24874630)
	Duel.SendtoDeck(tc,tp,2,REASON_RULE)
end