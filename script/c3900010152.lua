--Karakura Team
local s,id=GetID()
function s.initial_effect(c)
	--Special summon 1 level 5 or lower fusion monster from extra deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x39a1}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function s.cfilter(c)
	return c:IsMonster() and c:IsSetCard(0x39a1) and c:IsAbleToGraveAsCost()
end
function s.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x39a1) and c:IsLinkBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,cg:GetClassCount(Card.GetCode))
	end
	local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,cg:GetClassCount(Card.GetCode))
	local lvt={}
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		local tlv=0
		tlv=tlv+tc:GetLink()
		lvt[tlv]=tlv
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	for i=1,lv do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rg2=cg:Select(tp,1,1,nil)
		cg:Remove(Card.IsCode,nil,rg2:GetFirst():GetCode())
		rg1:Merge(rg2)
	end
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	tc:SetMaterial(rg1)
	Duel.SendtoGrave(rg1,REASON_COST+REASON_MATERIAL)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_EXTRA)
end
function s.sfilter(c,e,tp,lv)
	return c:IsSetCard(0x39a1) and c:IsLinkBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc then Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP) end
end