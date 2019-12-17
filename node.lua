node.alias("text")

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local json = require "json"
local text = require "text"

util.resource_loader{
    "dejavu_sans.ttf"
}

local write = text{font=dejavu_sans, width=WIDTH, height=HEIGHT, r=1, g=1, b=1}

local data = {}

util.file_watch("data.json", function(data_text)
    data = json.decode(data_text)
end)

function node.render()
    gl.clear(0, 0, 0, 1)
    if data == json.null then
        write{text={{"" .. WIDTH .. "x" .. HEIGHT}}}
    else
        write{text=data}
    end
end
