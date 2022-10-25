--Captain of the 11th Division - Zaraki "Kenpachi"
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetFieldGroup(c:GetControler(),0,LOCATION_MZONE)
	return g:GetSum(Card.GetAttack)>=3000
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		for tp=0,1 do
			Duel.Damage(tp,ct:FilterCount(Card.IsControler,nil,tp)*500,REASON_EFFECT)
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT+REASON_BATTLE~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHanlder()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)> end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,c:GetLocation())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHanlder()
	local atk=c:GetPreviousAttackOnField()-3000
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			--Increase ATK/DEF
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk+1000)
			c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end