--Orcustrion, the Orcust of the Sorrow Symphony
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--You can only Special Summon "Orcustrion, the Orcust of the Sorrow Symphony(s)" once per turn
	c:SetSPSummonOnce(id)
	--Fusion Summon procedure
	Fusion.AddProcMix(c,true,true,s.matfilter,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT))
	--Alternative Summon procedure
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
end
s.listed_names={id}
s.listed_series={SET_ORCUST}
s.material_setcode={SET_ORCUST}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_LINK,fc,sumtype,tp) and c:IsSetCard(SET_ORCUST,fc,sumtype,tp)
end
function s.matfilter2(c)
	return c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_SZONE) or aux.SpElimFilter(c,false,true))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,nil)
end
function s.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST|REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end