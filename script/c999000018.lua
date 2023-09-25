--Evilswarm Yidhra
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	--Change 1 monster to face-up or face-down Defense Position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(s.poscost)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
end
s.listed_series={0xa}
function s.poscfilter(c)
	return c:IsSetCard(0xa) and c:IsMonster() and c:IsAbleToGraveAsCost()
end
function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.poscfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.poscfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.posfilter(c)
	return not c:IsPosition(POS_FACEUP) or c:IsCanTurnSet()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		if tc:IsPosition(POS_FACEUP_DEFENSE) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		elseif tc:IsPosition(POS_FACEUP_ATTACK) and not tc:IsCanTurnSet() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else 
			local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE|POS_FACEDOWN_DEFENSE)
			Duel.ChangePosition(tc,pos)
		end
	end
end