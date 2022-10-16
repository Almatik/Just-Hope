--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
	aux.GlobalCheck(s,function()
		local se1=Effect.CreateEffect(c)
		se1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		se1:SetCode(EVENT_SUMMON_SUCCESS)
		se1:SetOperation(s.checkop)
		c:RegisterEffect(se1)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(43096270) and ep==tp then
		Duel.RegisterFlagEffect(ep,id,0,0,0)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return DuelLinks.IsEndPhase() and DuelLinks.IsTurnPlayer(tp)
		and Duel.GetFlagEffect(ep,id)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end