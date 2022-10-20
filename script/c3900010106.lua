--Karakura Toy - Kon
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

end
function s.filter1(c,e,tp,oc)
	local m=c:GetMetatable(true)
	if not m then return false end
	local bn=m.bleach_name
	return bn and c:IsSetCard(0x39a1)
		and c:IsAbleToGrave()
		and oc:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,bn)
end
function s.filter2(c,e,tp,mc,bn)
	local m=c:GetMetatable(true)
	if not m then return false end
	local lbn=m.bleach_name
	return lbn==bn and c:IsSetCard(0x39a1)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,c)
	local tc=g1:GetFirst()
	local tm=tc:GetMetatable(true)
	if not tm then return false end
	local bn=tm.bleach_name
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local tl=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,bn):GetFirst()
		local g=Group.FromCards(c,tc)
		tl:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if tl then Duel.SpecialSummon(tl,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP) end
	end
end