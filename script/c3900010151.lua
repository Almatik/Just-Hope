--Karakura Town
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--Karakura
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--Shinigami
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--Shinigami
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	--Shinigami
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(id,4))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCondition(s.con4)
	e4:SetTarget(s.tg4)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
	--Shinigami
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(id,5))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetCondition(s.con5)
	e5:SetTarget(s.tg5)
	e5:SetOperation(s.op5)
	c:RegisterEffect(e5)
end
s.listed_names={0x39a1,0x39a2}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.thfilter(c,e,tp)
	return c:IsSetCard(0x39a1) and c:IsMonster()
		and ((c:IsAbleToHand() and c:IsLocation(LOCATION_DECK))
		or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND)))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		if g:GetFirst():IsLocation(LOCATION_DECK) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end




function s.confilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x39a1) and c:IsControler(tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter1,1,nil,tp)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end



function s.confilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x39a2) and c:IsControler(tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter2,1,nil,tp)
end
function s.filter2(c)
	return c:IsMonster() and c:IsAbleToDeck()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end



function s.confilter3(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x39a8) and c:IsControler(tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter3,1,nil,tp)
end
function s.filter3(c)
	return c:IsReason(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK) and eg:IsContains(c:GetReasonCard()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter3(chkc,eg,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter3,tp,LOCATION_GRAVE,0,1,nil,eg,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_GRAVE,0,1,1,nil,eg,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end



function s.confilter4(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x39a5) and c:IsControler(tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter4,1,nil,tp)
end
function s.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end



function s.confilter5(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x39a9) and c:IsControler(tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter5,1,nil,tp)
end
function s.filter5(c)
	return c:IsMonster() and c:IsAbleToRemove()
end
function s.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.filter5(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter5,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter5,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end