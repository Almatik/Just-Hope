HINT_SKILL = 200
HINT_SKILL_COVER = 201
HINT_SKILL_FLIP  = 202
HINT_SKILL_REMOVE = 203

if not aux.DLProcedure then
	aux.DLProcedure = {}
	DuelLinks = aux.DLProcedure
end
if not DuelLinks then
	DuelLinks = aux.DLProcedure
end


-- "c"": the card (card)
-- "skillcon": condition to activate the skill (function)
-- "skillop": operation related to the skill activation (function)
-- "countlimit": number of times you can use this skill
-- "setcode": the EVENT code

function DuelLinks.AddProcedure(c,skillcon,skillop)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(DuelLinks.Place())
	c:RegisterEffect(e1)
end
function DuelLinks.PreStart(c,skillcon,skillop,countlimit)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	if type(countlimit)=="number" then
		e1:SetCountLimit(countlimit)
	end
	if skillcon~=nil then
		e1:SetCondition(skillcon)
	end
	e1:SetOperation(skillop)
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
		Duel.Hint(HINT_SKILL_COVER,c:GetControler(),c:GetCode()|(1<<32))
		Duel.Hint(HINT_SKILL,c:GetControler(),c:GetCode())
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
			if skillcon~=nil then
				e1:SetCondition(skillcon)
			end
			e1:SetOperation(skillop)
			Duel.RegisterEffect(e1,e:GetHandlerPlayer())
		end
	end
end


--  Skill Flip Functions
function DuelLinks.FlipUp(c)
	Duel.Hint(HINT_SKILL_FLIP,c:GetControler(),c:GetCode()|(1<<32))
end
function DuelLinks.FlipDown(c)
	Duel.Hint(HINT_SKILL_FLIP,c:GetControler(),c:GetCode()|(2<<32))
end

-- Phase Functions
function DuelLinks.IsDrawPhase()
	return Duel.GetCurrentPhase()==PHASE_DRAW
end
function DuelLinks.IsStandbyPhase()
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function DuelLinks.IsMainPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function DuelLinks.IsBattlePhase()
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function DuelLinks.IsEndPhase()
	return Duel.GetCurrentPhase()==PHASE_END
end

--  Turn Functions
function DuelLinks.IsTurn(num)
	return Duel.GetTurnCount()==num
end
function DuelLinks.IsTurnPlayer(player)
	return Duel.GetTurnPlayer()==player
end

-- Check Summon
function DuelLinks.IsSummoned()
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function DuelLinks.IsSummonedOp(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end