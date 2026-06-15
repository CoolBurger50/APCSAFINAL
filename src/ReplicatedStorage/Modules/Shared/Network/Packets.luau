local Packet = require(script.Packet)

return {
	FeintServer = Packet("FeintServer");
	cancelAnimation = Packet("cancelAnimation");
	SetAttribute = Packet("SetAttribute", Packet.Any, Packet.Any);
}