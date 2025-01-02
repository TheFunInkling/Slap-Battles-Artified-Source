local module = {}

function module.tableToString(t)
	local s = ""
	for i = 1,#t do
		s = s..tostring(t)
		if i ~= #t then
			s = s..","
		end
	end
	return s
end

function module.stringToTable(s)
	local t = {}
	local currentString = ""
	for i = 1,#s do
		if string.sub(s,i,i) == "," then
			table.insert(t,currentString)
			currentString = ""
		else
			currentString = currentString..string.sub(s,i,i)
		end
	end
	return t
end


return module
