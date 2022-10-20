--Destiny Draw: Monster Reborn
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	DuelLinks.AddProcedure(c)
	DuelLinks.Predraw(c,s.flipcon,s.flipop,1)
end
function s.filter(c)
	return c:IsAttackAbove(3000) and c:IsFaceup()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0
		and Duel.GetTurnPlayer()==tp
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,83764718)
		and (Duel.GetLP(tp)<=6000 or Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	--draw replace
	DuelLinks.FlipUp(e:GetHandler())
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,83764718)
	if #tc~=0 then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end