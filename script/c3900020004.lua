--Tag Skill
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddVrainsSkillProcedure(c,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,RESET_PHASE+PHASE_END)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.TagSwap(tp)
end