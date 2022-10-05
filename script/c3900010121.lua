--Karakura Shinigami - Ichigo
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()

end
s.listed_names={id,BLEACH_ICHIGO}
s.listed_series={0x39a1,0x39a2}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x39a1,lc,sumtype,tp)
		and g:GetClassCount(Card.GetCode)==#g
end