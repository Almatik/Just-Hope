if not aux.DLProcedure then
	aux.DLProcedure = {}
	DuelLinks = aux.DLProcedure
end
if not DuelLinks then
	DuelLinks = aux.DLProcedure
end

-- "Proc for basic skill"
-- c: the card (card)
-- skillcon: condition to activate the skill (function)
-- skillop: operation related to the skill activation (function)
-- countlimit: number of times you can use this skill
-- setcode: the EVENT code

function DuelLinks.AddProcedure(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(DuelLinks.Place())
	c:RegisterEffect(e1)
end
function DuelLinks.Predraw(c,skillcon,skillop,countlimit)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(DuelLinks.SkillOp(skillcon,skillop,countlimit,EVENT_PREDRAW))
	c:RegisterEffect(e1)
end
function DuelLinks.Ignition(c,skillcon,skillop,countlimit)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(DuelLinks.SkillOp(skillcon,skillop,countlimit,EVENT_FREE_CHAIN))
	c:RegisterEffect(e1)
end
function DuelLinks.Trigger(c,skillcon,skillop,countlimit,setcode)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(DuelLinks.SkillOp(skillcon,skillop,countlimit,setcode))
	c:RegisterEffect(e1)
end

-- Place Skill to the Field
function DuelLinks.Place()
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.DisableShuffleCheck(true)
		Duel.SendtoDeck(c,tp,-2,REASON_RULE)
		--generate the skill in the "skill zone"
		Duel.Hint(HINT_SKILL_COVER,c:GetControler(),VRAINS_SKILL_COVER)
		Duel.Hint(HINT_SKILL,c:GetControler(),c:GetCode())
	local tc=Duel.CreateToken(tp,24874630)
	Duel.SendtoDeck(tc,tp,2,REASON_RULE)
	end
end

-- Use Ignition Effect
function DuelLinks.SkillOp(skillcon,skillop,countlimit,setcode)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if skillop~=nil then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(setcode)
			if type(countlimit)=="number" then
				e1:SetCountLimit(countlimit)
			end
			e1:SetCondition(skillcon)
			e1:SetOperation(skillop)
			Duel.RegisterEffect(e1,e:GetHandlerPlayer())
		end
	end
end






