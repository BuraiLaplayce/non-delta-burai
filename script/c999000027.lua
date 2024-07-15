--Ludwig, the Orcust Conductor
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	--Link summon method
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
		--Activate 1 "Ursarctic Big Dipper" from your Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.accost)
	e2:SetCondition(s.accon)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_ORCUST}
s.listed_names={90351981}
	--Link material of a non-link "Traptrix" monster
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(SET_ORCUST,lc,sumtype,tp) and not c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function s.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.fieldfilter(c,tp)
	return c:IsCode(90351981) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.fieldfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end