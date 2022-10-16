--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SUMMON_SUCCESS)
	ge1:SetOperation(s.checkop)
	c:RegisterEffect(ge1)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(43096270) and tc:IsControler()==tp then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return DuelLinks.IsEndPhase() and DuelLinks.IsTurnPlayer(tp)
		and Duel.GetFlagEffect(tp,id)~=0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end