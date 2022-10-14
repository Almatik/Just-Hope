--Blue-Blooded Vampire
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum: Search or send to GY
	local pe1=Effect.CreateEffect(c)
	pe1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	pe1:SetDescription(aux.Stringid(id,0))
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetCountLimit(1,{id,1})
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetTarget(s.pentarget)
	pe1:SetOperation(s.penoperation)
	c:RegisterEffect(pe1)
	--Cannot Normal Summon/Set
	c:EnableUnsummonable()
	--Monster: Cannot SP Summon
	local me1=Effect.CreateEffect(c)
	me1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	me1:SetType(EFFECT_TYPE_SINGLE)
	me1:SetCode(EFFECT_SPSUMMON_CONDITION)
	me1:SetValue(s.spcon)
	c:RegisterEffect(me1)
	--Monster: Normal Summon
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,2})
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.penfilter(c)
	return c:IsSetCard(0x8e) and c:IsMonster() and (c:IsAbleToHand() or c:IsAbleToGrave()) and not c:IsCode(id)
end
function s.pentarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.penoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	aux.ToHandOrElse(g:GetFirst(),tp)
end


function s.spcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_HAND)
end


function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sel={}
	table.insert(sel,aux.Stringid(id,1))
	table.insert(sel,aux.Stringid(id,2))
	--Choose Effect
	if c:IsPreviousLocation(LOCATION_HAND) then
		local selop=Duel.SelectOption(tp,false,table.unpack(sel))
	elseif c:IsPreviousLocation(LOCATION_EXTRA) then
		local selop=2
	end
	--Apply Effect
	if selop==0 or selop==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x8e))
		c:RegisterEffect(e1)
	end
	if selop==1 or selop==2 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SUMMON_PROC)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetCountLimit(1)
		e2:SetCondition(s.ntcon)
		e2:SetTarget(aux.FieldSummonProcTg(s.nttg))
		c:RegisterEffect(e2)
	end
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x8e)
end