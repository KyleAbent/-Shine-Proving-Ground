local Plugin = {}
local Shine = Shine

Plugin.Version = "1.0"
Plugin.HasConfig = true
Plugin.ConfigName = "SpectatorMods.json"
Plugin.DefaultConfig = {
	SpecsCanHearAllVoiceComms = true,
	SpectatorsDontTakeSlots = true,
	SendMessageOnJoinSpec = true,
	JoinSpecMessage = "Control which team voices you hear (M > Proving Ground > Spec Voice)",
}
Plugin.CheckConfig = true
Plugin.CheckConfigTypes = true

Plugin.DefaultState = true

Shine:RegisterExtension("provingground", Plugin )
