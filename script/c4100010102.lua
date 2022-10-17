--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
end
function s.filter(c)
	return :IsSummonType(SUMMON_TYPE_NORMAL) and c:IsStatus(STATUS_SUMMON_TURN)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end