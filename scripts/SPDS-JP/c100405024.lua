--魔界台本「オープニング・セレモニー」
--Abyss Script - Opening Ceremony
--Script by mercury233
function c100405024.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100405024)
	e1:SetTarget(c100405024.target)
	e1:SetOperation(c100405024.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,100405924)
	e2:SetCondition(c100405024.drcon)
	e2:SetTarget(c100405024.drtg)
	e2:SetOperation(c100405024.drop)
	c:RegisterEffect(e2)
end
function c100405024.filter1(c)
	return c:IsSetCard(0x11ed) and c:IsFaceup()
end
function c100405024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rec=Duel.GetMatchingGroupCount(c100405024.filter1,tp,LOCATION_MZONE,0,nil)*500
	if chk==0 then return rec>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c100405024.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec=Duel.GetMatchingGroupCount(c100405024.filter1,tp,LOCATION_MZONE,0,nil)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
function c100405024.filter2(c)
	return c:IsSetCard(0x11ed) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c100405024.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c100405024.filter2,tp,LOCATION_EXTRA,0,1,nil)
end
function c100405024.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c100405024.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
