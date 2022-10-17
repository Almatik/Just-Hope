--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,nil,s.summop,1,EVENT_SUMMON_SUCCESS)
	s[0]=false
	s[1]=false
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
end
function s.summop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(43096270) then
			s[tc:GetSummonPlayer()]=true
			Duel.Draw(tp,1,REASON_RULE)
		end
		tc=eg:GetNext()
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return s[tp]
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end