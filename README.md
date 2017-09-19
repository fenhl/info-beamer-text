This is a helper library for rendering rich text with [info-beamer](https://github.com/dividuum/info-beamer).

# Usage

```lua
util.resource_loader{
    "some_font.ttf",
}
local write = (require "text")(some_font, WIDTH, HEIGHT)
write{text={{"Hello", "world!"}}}
```

**TODO**

# Features

Features with a checkmark are available, unchecked features are planned.

- [x] Write text given in a specific format to the screen. Format example:
    ```lua
    {{"This", "is", "a", "paragraph,"}, {"and", "this", "is", "another", "paragraph."}}
    ```
- [x] Automatic word wrapping
- [ ] Simulation mode: only determine width and height without rendering
- [x] Custom base text size
- [ ] Variable text size
- [ ] Text colors and opacity
- [x] Specify bounds for the text area
- [x] Horizontal alignment (left, center, or right)
- [ ] Vertical alignment (top, middle, or bottom)
- [ ] Custom word separators, maybe-breaks, and hyphenation
- [ ] Custom emoji
- [ ] Unicode emoji
- [ ] Bold, italic, and underlined text
- [ ] Plugin support (render things like images inline)
