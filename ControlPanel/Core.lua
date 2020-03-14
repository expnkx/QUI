local ControlPanel = LibStub("AceAddon-3.0"):GetAddon("ControlPanel")
--------------------------------------------------------------------------------------

local function equal(cvar,val)
	local tp = type(val)
	if tp == "boolean" then
		return GetCVarBool(cvar)==val
	elseif tp == "number" then
		return GetCVar(cvar)==tostring(val)
	else
		return GetCVar(cvar)==val
	end
end

function ControlPanel:UpdateWorld(t)
	local tb = self.db.profile[t]
	if tb then
		for k,v in pairs(tb) do
			if not equal(k,v) then
				SetCVar(k,v)
			end
		end
	end
end

function ControlPanel:OnEnable()
	self:UpdateWorld("none")
	local sm = self.db.profile.shared_media
	if sm then
		local tb = LibStub("LibSharedMedia-3.0",true)
		if tb then
			for k,v in pairs(sm) do
				for kk,vv in pairs(v) do
					tb:Register(k,kk,vv)
				end
			end
		end
	end
end

function ControlPanel:GetInstanceType()
	if IsResting() then
		return "rest"
	end
	local _,v = GetInstanceInfo()
	return v;
end

function ControlPanel:GetProfileType()
	local profile = self.db.profile
	local instance = self:GetInstanceType()
	if profile[instance] then
		if instance ~= "none" and profile["enable_"..instance] then
			return instance;
		end
	end
	return "none"
end

function ControlPanel:SetCVarInstance(t,key,value)
	local sdpt = self.db.profile[t]
	if t=="temp" or sdpt == nil then
		SetCVar(key,value)
		sdpt = {[key]=value}
		self.db.profile[t] = sdpt
	else
		if self:GetProfileType() == t then
			SetCVar(key,value)
		end
		sdpt[key] = value
	end
	if next(sdpt) == nil then
		self.db.profile[t] = nil
	end
end

function ControlPanel:GetCVarNumberInstance(t,key)
	local v = self.db.profile[t]
	if t=="temp" or v ==nil or v[key] == nil then
		return tonumber(GetCVar(key))
	end
	return v[key]
end

function ControlPanel:GetCVarBoolInstance(t,key)
	local v = self.db.profile[t]
	if t=="temp" or v ==nil or v[key] == nil then
		return GetCVarBool(key)
	end
	return v[key]
end

function ControlPanel:GetCVarInstance(t,key)
	local v = self.db.profile[t]
	if t=="temp" or v ==nil or v[key] == nil then
		return GetCVar(key)
	end
	return v[key]
end

function ControlPanel:FireCVarInstance(t,key)
	local v = self.db.profile[t]
	if v then
		v[key] = nil
		if next(v) == nil then
			self.db.profile[t] = nil
		end
	end
end

function ControlPanel:PLAYER_ENTERING_WORLD()
	self:UpdateWorld(self:GetProfileType())
end