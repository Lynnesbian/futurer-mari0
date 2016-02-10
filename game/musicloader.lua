music = {
	loaded = {},
	list = {},
	list_fast = {},
	pitch = 1,
}

local musicpath = "sounds/%s.ogg"
local function getfilename(name)
	local filename = name:match("%.[mo][pg][3g]$") and name or musicpath:format(name) -- mp3 or ogg
	if love.filesystem.exists(filename) and love.filesystem.isFile(filename) then
		return filename
	else
		print(string.format("thread can't load \"%s\": not a file!", filename))
	end
end

function music:load(musicfile) -- can take a single file string or an array of file strings
	if type(musicfile) == "table" then
		for i,v in ipairs(musicfile) do
			self:preload(v)
		end
	else
		self:preload(musicfile)
	end
end

function music:preload(musicfile)
	if self.loaded[musicfile] == nil then
		local filename = getfilename(musicfile)
		local source = love.audio.newSource(filename)
		self:onLoad(musicfile, source)
	end
end

function music:play(name)
	if name and soundenabled then
		if self.loaded[name] then
			playsound(self.loaded[name])
		end
	end
end

function music:playIndex(index, isfast)
	local name = isfast and self.list_fast[index] or self.list[index]
	self:play(name)
end

function music:stop(name)
	if name and self.loaded[name] then
		love.audio.stop(self.loaded[name])
	end
end

function music:stopIndex(index, isfast)
	local name = isfast and self.list_fast[index] or self.list[index]
	self:stop(name)
end

function music:update()
	for name, source in pairs(self.loaded) do
		if source ~= false then
			source:setPitch(self.pitch)
		end
	end
end

function music:onLoad(name, source)
	self.loaded[name] = source
	source:setLooping(true)
	source:setPitch(self.pitch)
end

local toload = {
	"overworld",
	"overworld-fast",
	"underground",
	"underground-fast",
	"castle",
	"castle-fast",
	"underwater",
	"underwater-fast",
	"starmusic",
	"starmusic-fast",
	"princessmusic",
}
music:load(toload)

-- the original/default music needs to be put in the correct lists
for i,v in ipairs(toload) do
	if v:match("fast") then
		table.insert(music.list_fast, v)
	elseif not v:match("princessmusic") then
		table.insert(music.list, v)
	end
end
