--魔界劇団－ファンキー・コメディアン
--Abyss Actor - Funky Comedian
--Script by mercury233
function c100405017.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up (p zone)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100405017,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c100405017.atkcost1)
	e1:SetTarget(c100405017.atktg1)
	e1:SetOperation(c100405017.atkop1)
	c:RegisterEffect(e1)
	--atk up (summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c100405017.atkcon2)
	e2:SetOperation(c100405017.atkop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk up (m zone)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100405017)
	e4:SetCost(c100405017.atkcost3)
	e4:SetTarget(c100405017.atktg3)
	e4:SetOperation(c100405017.atkop3)
	c:RegisterEffect(e4)
end
function c100405017.atkfilter1(c,tp)
	return c:IsSetCard(0x11ed) and Duel.IsExistingTarget(c100405017.tgfilter,tp,LOCATION_MZONE,0,1,c)
end
function c100405017.atkfilter2(c)
	return c:IsSetCard(0x11ed) and c:IsFaceup()
end
function c100405017.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100405017.atkfilter1,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100405017.atkfilter1,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetBaseAttack())
	Duel.Release(g,REASON_COST)
end
function c100405017.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100405017.atkfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100405017.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100405017.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100405017.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100405017.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c100405017.atkfilter2,tp,LOCATION_MZONE,0,nil)>0
end
function c100405017.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atkval=Duel.GetMatchingGroupCount(c100405017.atkfilter,tp,LOCATION_MZONE,0,nil)*300
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c100405017.atkcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c100405017.atktg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100405017.atkfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100405017.atkfilter2,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c100405017.atkfilter2,tp,LOCATION_MZONE,0,1,1,c)
end
function c100405017.atkop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=c:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end
