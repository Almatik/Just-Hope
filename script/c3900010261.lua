--Off. of the 11th Division - Yumichika Ayasegawa
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(s.retcon)
	e1:SetTarget(s.rettg)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)
end
function s.retfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x39a2)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.retfilter,tp,LOCATION_MZONE,0,nil):GetCount()>1
		and Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil):GetCount()>0
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.retfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	g:AddCard(g1)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	sg:Sub(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	local tg=Duel.GetTargetCards(e)
	if tg:IsExists(Card.IsControler,1,nil,tp) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1 then
		sg:Merge(g)
	end
	sg:Sub(tg)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
end