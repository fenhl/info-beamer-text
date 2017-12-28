function write_inner(font, simulate, text, size, min_x, max_x, min_y, max_y, indent, halign, valign, r, g, b, a)
    -- first, calculate y offset from number of lines
    local y
    if valign == "top" then
        y = min_y
    else
        local text_height = write_inner(font, true, text, size, min_x, max_x, min_y, max_y, indent, halign, "top", r, g, b, a).height
        if valign == "middle" then
            y = min_y + ((max_y - min_y) - text_height) / 2
        else -- valign == "bottom"
            y = max_y - text_height
        end
    end
    -- then, draw the text
    local height = 0
    local width = 0
    local line
    local line_width
    local num_paragraphs = #text
    local num_words
    local test_line
    local x = indent
    local final_indent = min_x
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
            if (x ~= nil and line_width > (max_x - x)) or (line_width > (max_x - min_x) and line ~= "") then
                if x ~= nil then
                    x = x
                elseif halign == "left" then
                    x = min_x
                elseif halign == "center" then
                    x = min_x + ((max_x - min_x) - font:width(line, size)) / 2
                elseif halign == "right" then
                    x = max_x - font:width(line, size)
                end
                if not simulate then
                    font:write(x, y, line, size, r, g, b, a)
                end
                y = y + size
                x = nil
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
        if x ~= nil then
            x = x
        elseif halign == "left" then
            x = min_x
        elseif halign == "center" then
            x = min_x + ((max_x - min_x) - font:width(line, size)) / 2
        elseif halign == "right" then
            x = max_x - font:width(line, size)
        end
        if not simulate then
            font:write(x, y, line, size, r, g, b, a)
        end
        final_indent = x + font:width(line, size)
    end
    return {
        width=width,
        height=height,
        final_indent=final_indent,
        final_indent_space=final_indent + font:width(" ", size)
    }
end

return function(factory_args)
    return function(args)
        local red
        local green
        local blue
        if args.color ~= nil then
            red = args.color.r or args.color[1]
            green = args.color.g or args.color[2]
            blue = args.color.b or args.color[3]
        else
            red = args.r or factory_args.r or 1
            green = args.g or factory_args.g or 1
            blue = args.b or factory_args.b or 1
        end
        return write_inner(
            args.font or factory_args.font,
            args.simulate or false,
            args.text,
            args.size or factory_args.size or 100,
            args.min_x or (args.size or 100) / 2,
            args.max_x or factory_args.width - (args.size or 100) / 2,
            args.min_y or (args.size or 100) / 2,
            args.max_y or factory_args.height - (args.size or 100) / 2,
            args.indent,
            args.halign or "center",
            args.valign or "middle",
            red,
            green,
            blue,
            args.a or factory_args.a or 1
        )
    end
end
