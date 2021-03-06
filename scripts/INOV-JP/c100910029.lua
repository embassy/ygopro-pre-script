--PSYフレーム・マルチスレッダー
--PSY-Frame Multi-Threader
--Script by nekrozar
function c100910029.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(49036338)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c100910029.reptg)
	e2:SetValue(c100910029.repval)
	e2:SetOperation(c100910029.repop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100910029,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100910029)
	e3:SetCondition(c100910029.spcon)
	e3:SetTarget(c100910029.sptg)
	e3:SetOperation(c100910029.spop)
	c:RegisterEffect(e3)
end
function c100910029.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc1) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c100910029.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and eg:IsExists(c100910029.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(100910029,0))
end
function c100910029.repval(e,c)
	return c100910029.repfilter(c,e:GetHandlerPlayer())
end
function c100910029.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
end
function c100910029.cfilter(c,tp)
	return c:IsSetCard(0xc1) and c:IsType(TYPE_TUNER) and c:IsControler(tp)
end
function c100910029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100910029.cfilter,1,nil,tp)
end
function c100910029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100910029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
