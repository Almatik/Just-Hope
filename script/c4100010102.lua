--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,nil,s.summop,1,EVENT_SUMMON_SUCCESS)
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
end
function s.summop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(43096270) and ep==e:GetHandlerPlayer() then
			Duel.RegisterFlagEffect(ep,{id,0},RESET_PHASE+PHASE_END,0,0)
			Duel.Draw(tp,1,REASON_RULE)
		end
		tc=eg:GetNext()
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return Duel.GetFlagEffect(ep,{id,0})>0
		and ep==e:GetHandlerPlayer()
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end