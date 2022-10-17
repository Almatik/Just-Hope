--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Trigger(c,s.flipcon,s.flipop,1,EVENT_PHASE+PHASE_END)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.checkop)
	c:RegisterEffect(e1)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_RULE)
	local tc=eg:GetFirst()
	if tc:IsCode(43096270) and tc:IsControler()==tp then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return Duel.GetTurnPlayer()==tp
		and Duel.GetFlagEffect(tp,id)~=0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	for tp=0,1 do
		local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(tp,num,REASON_RULE)
	end
end