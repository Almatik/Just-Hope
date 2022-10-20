--Destiny Draw
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c,nil,nil)
	DuelLinks.CheckLP(s,tp)
	DuelLinks.Predraw(c,flipcon,flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
		and DuelLinks.LostLP(s,tp,2000)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	--draw replace
	DuelLinks.FlipUp(e:GetHandler())
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local tc=aux.SelectUnselectGroup(g,e,tp,1,1,aux.dncheck,1,tp)
	if #tc~=0 then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end