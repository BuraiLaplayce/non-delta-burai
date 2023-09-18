--Heroic Champion - Lion Heart
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x6f),4,2,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	--Cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
end
s.listed_series={0x6f}
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:GetRank()==1 and c:IsType(TYPE_XYZ,lc,SUMMON_TYPE_XYZ,tp) 
	and c:IsRace(RACE_WARRIOR,lc,SUMMON_TYPE_XYZ,tp)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	return true
end
function s.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:GetBattledGroupCount()==0
	and re:IsActiveType(TYPE_MONSTER)
end