-- See FrameXML CopyTable (https://www.townlong-yak.com/framexml/live/Blizzard_SharedXMLBase/TableUtil.lua#218)
function CopyMissingTableFields(copyFrom, copyTo)
	for k, v in pairs(copyFrom) do
		if type(v) == "table" then
			copyTo[k] = copyTo[k] or {}
			CopyMissingTableFields(v, copyTo[k])
		elseif copyTo[k] == nil then
			copyTo[k] = v
		end
	end
end
