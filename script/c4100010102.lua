--Card of Sanctity
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,s.flipop)
	DuelLinks.Ignition(c,s.flipcon,s.flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,tp)
	return
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	DuelLinks.FlipUp(e:GetHandler())
	local num=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.Draw(tp,num,REASON_RULE)
end