function write_inner(font, text, size, min_x, max_x, min_y, max_y, halign)
    --TODO make the following customizable
    local r = 1
    local g = 1
    local b = 1
    local a = 1
    -- first, calculate y offset from number of lines
    local y = min_y --TODO valign
    -- then, draw the text
    local height = 0
    local width = 0
    local line
    local line_width
    local num_paragraphs = #text
    local num_words
    local test_line
    local x
    for paragraph = 1, num_paragraphs do
        if paragraph > 1 then
            y = y + size * 1.5
            height = height + size * 1.5
        else
            height = height + size
        end
        line = ""
        num_words = #text[paragraph]
        for word = 1, num_words do
            if line == "" then
                test_line = text[paragraph][word]
            else
                test_line = line .. " " .. text[paragraph][word]
            end
            line_width = font:width(test_line, size)
            if line_width > (max_x - min_x) and line ~= "" then
                if halign == "left" then
                    x = min_x
                elseif halign == "center" then
                    x = min_x + ((max_x - min_x) - font:width(line, size)) / 2
                elseif halign == "right" then
                    x = max_x - font:width(line, size)
                end
                font:write(x, y, line, size, r, g, b, a)
                y = y + size
                height = height + size
                line = text[paragraph][word]
                if font:width(line, size) > width then
                    width = font:width(line, size)
                end
            else
                line = test_line
                if line_width > width then
                    width = line_width
                end
            end
        end
        if halign == "left" then
            x = min_x
        elseif halign == "center" then
            x = min_x + ((max_x - min_x) - font:width(line, size)) / 2
        elseif halign == "right" then
            x = max_x - font:width(line, size)
        end
        font:write(x, y, line, size, r, g, b, a)
    end
    return {width=width, height=height}
end

return function(default_font, WIDTH, HEIGHT)
    return function(args)
        return write_inner(
            args.font or default_font,
            args.text,
            args.size or 100,
            args.min_x or (args.size or 100) / 2,
            args.max_x or WIDTH - (args.size or 100) / 2,
            args.min_y or (args.size or 100) / 2,
            args.max_y or HEIGHT - (args.size or 100) / 2,
            args.halign or "center"
        )
    end
end
