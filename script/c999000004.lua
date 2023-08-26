--Red-Eyes Darkness Encore Metal Dragon
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,true,true,s.mfilter1,s.mfilter2)
	c:EnableReviveLimit()
end
s.listed_series={SET_RED_EYES}
function s.mfilter1(c,fc,sumtype,tp)
	return c:IsSetCard(0x3b,fc,sumtype,tp) and c:GetLevel()==7
end
function s.mfilter2(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetLevel()>=10
end
