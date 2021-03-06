--グレイドル・コンバット
--Graydle Combat
--Script by mercury233
function c100910075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c100910075.condition)
	e1:SetTarget(c100910075.target)
	e1:SetOperation(c100910075.activate)
	c:RegisterEffect(e1)
end
function c100910075.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xd1)
end
function c100910075.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return c100910075.cfilter(tc,tp) 
end
function c100910075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and (Duel.IsChainNegatable(ev) or tc:IsDestructable()) end
	local sel=0
	if Duel.IsChainNegatable(ev) and tc:IsDestructable() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(100910075,0),aux.Stringid(100910075,1))
	elseif tc:IsDestructable() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(100910075,0))
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(100910075,1))+1
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end
end
function c100910075.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.ChangeChainOperation(ev,c100910075.repop)
	else
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c100910075.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
