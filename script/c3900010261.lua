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
function s.retfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x39a2)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.retfilter,tp,LOCATION_MZONE,0,nil):GetCount()>1
		and Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil):GetCount()>0
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,s.retfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,tc)
	if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end