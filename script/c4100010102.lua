--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,s.summcon,s.summop,1,EVENT_SUMMON_SUCCESS)
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(43096270) then
			return true
		end
	end
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return Duel.GetFlagEffect(tp,id)~=0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end