function space_before(first_of_line, formatted_word)
    if formatted_word.space_before == nil then
        return not first_of_line
    else
        return formatted_word.space_before
    end
end

function write_formatted_line(x, y, halign, min_x, max_x, line_width, line_height, simulate, line)
    if x ~= nil then
        x = x
    elseif halign == "left" then
        x = min_x
    elseif halign == "center" then
        x = min_x + ((max_x - min_x) - line_width) / 2
    elseif halign == "right" then
        x = max_x - line_width
    end
    if not simulate then
        for i = 1, #line do
            local text
            if space_before(i == 1, line[i]) then
                text = " " .. line[i].word
            else
                text = line[i].word
            end
            x = x + line[i].font:write(x, y + line_height - line[i].size, text, line[i].size, line[i].r, line[i].g, line[i].b, line[i].a)
        end
    end
    return x
end

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
    local num_paragraphs = #text
    local x = indent
    local final_indent = min_x
    for paragraph = 1, num_paragraphs do
        if paragraph > 1 then
            y = y + size * 0.5
            height = height + size * 0.5
        end
        local line_width = 0
        local line_height = 0
        local line = {}
        for word = 1, #text[paragraph] do
            local formatted_word
            if type(text[paragraph][word]) == "table" then
                local red
                local green
                local blue
                if text[paragraph][word].color ~= nil then
                    red = text[paragraph][word].color.r or text[paragraph][word].color[1]
                    green = text[paragraph][word].color.g or text[paragraph][word].color[2]
                    blue = text[paragraph][word].color.b or text[paragraph][word].color[3]
                else
                    red = text[paragraph][word].r or r
                    green = text[paragraph][word].g or g
                    blue = text[paragraph][word].b or b
                end
                formatted_word = {
                    font=text[paragraph][word].font or font,
                    word=text[paragraph][word].word,
                    size=text[paragraph][word].size or size,
                    space_before=text[paragraph][word].space_before,
                    r=red,
                    g=green,
                    b=blue,
                    a=text[paragraph][word].a or a
                }
            else
                formatted_word = {
                    font=font,
                    word=text[paragraph][word],
                    size=size,
                    space_before=nil,
                    r=r,
                    g=g,
                    b=b,
                    a=a
                }
            end
            local test_line_width
            if space_before(#line == 0, formatted_word) then
                test_line_width = line_width + formatted_word.font:width(" " .. formatted_word.word, formatted_word.size)
            else
                test_line_width = line_width + formatted_word.font:width(formatted_word.word, formatted_word.size)
            end
            if (x ~= nil and test_line_width > (max_x - x)) or (test_line_width > (max_x - min_x) and line ~= "") then
                write_formatted_line(x, y, halign, min_x, max_x, line_width, line_height, simulate, line)
                y = y + line_height
                x = nil
                line = {formatted_word}
                if line_width > width then
                    width = line_width
                end
                height = height + line_height
                line_width = formatted_word.font:width(formatted_word.word, formatted_word.size)
                line_height = formatted_word.size
            else
                line[#line + 1] = formatted_word
                if formatted_word.size > line_height then
                    line_height = formatted_word.size
                end
                line_width = test_line_width
            end
        end
        final_indent = write_formatted_line(x, y, halign, min_x, max_x, line_width, line_height, simulate, line)
        y = y + line_height
        if line_width > width then
            width = line_width
        end
        height = height + line_height
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
