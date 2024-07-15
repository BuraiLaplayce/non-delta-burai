--Ursarctic First Charge
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	--Activate and (you can) Special Summon 2 "Ursarctic" monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Tribute Substitute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(CARD_URSARCTIC_BIG_DIPPER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCountLimit(1)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.accon)
	e3:SetOperation(s.acop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_URSARCTIC}
s.listed_names={CARD_URSARCTIC_BIG_DIPPER,27693363}
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x165) and c:IsMonster() 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,c:GetLevel())
end
function s.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0x165) and c:IsMonster() and c:GetLevel()~=lv
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g1:GetFirst()
		local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,tc,e,tp,tc:GetLevel())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,cc) return not cc:HasLevel() end)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.repval(base,e,tp,eg,ep,ev,re,r,rp,chk,extracon)
	local c=e:GetHandler()
	return Duel.CheckLPCost(tp,700)
end
function s.repop(base,e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.PayLPCost(tp,700)
end
function s.activatefilter(c,tp)
	return (c:IsCode(CARD_URSARCTIC_BIG_DIPPER) or (c:IsSetCard(0x165) and c:IsType(TYPE_CONTINUOUS))) and not c:IsCode(id) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27693363),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.activatefilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc:IsType(TYPE_FIELD) then
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end