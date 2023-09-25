--PSY-Frame Teleport
--Scripted by Burai
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_series={0xc1}
s.listed_series={0x10c1}
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1250) end
	Duel.PayLPCost(tp,1250)
end
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0xc1) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(s.spfilter2,tp,0x13,0,1,c,e,tp)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x10c1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
--need to fix the banishing effect
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
--	local c=e:GetHandler()
--	local fid=c:GetFieldID()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter1),tp,0x13,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,0x13,0,1,1,g1:GetFirst(),e,tp)
	local g3=g1:Merge(g2)
	if #g3==2 then
		Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		local tc1=g1:GetFirst()
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		g1:AddCard(g2)
		g1:KeepAlive()
		--local tc1=g1:GetFirst()
		--local tc2=g2:GetFirst()
		if tc1 then
			tc1:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(g1)
			e1:SetCondition(s.rmcon)
			e1:SetOperation(s.rmop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
--		if tc2 then
--			tc2:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
--			local e2=Effect.CreateEffect(c)
--			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--			e2:SetCode(EVENT_PHASE+PHASE_END)
--			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
--			e2:SetCountLimit(1)
--			e2:SetLabel(fid)
--			e2:SetLabelObject(tc2)
--			e2:SetCondition(s.rmcon)
--			e2:SetOperation(s.rmop)
--			e2:SetReset(RESET_PHASE+PHASE_END)
--			Duel.RegisterEffect(e2,tp)
--		end
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
