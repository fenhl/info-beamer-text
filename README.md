**Maintenance notice:** This project is no longer maintained since I no longer use info-beamer. If you would like me to add a link to a maintained fork, please ping me in an issue.

This is a helper library for rendering rich text with [info-beamer](https://github.com/dividuum/info-beamer).

# Usage

```lua
util.resource_loader{
    "some_font.ttf",
}
local text = require "text" -- text.lua needs to be in the same directory as your node.lua
local write = text{font=some_font, width=WIDTH, height=HEIGHT} -- optional arguments: r, g, b, a (default: white), size (default: 100)
local dimensions = write{text={{"Hello", "world!"}}}
-- `dimensions` is a table containing `width` and `height` in pixels
```

**TODO**

# Features

Features with a checkmark are available, unchecked features are planned.

- [x] Write text given in a specific format to the screen. Format example:
    ```lua
    {{"This", "is", "a", "paragraph,"}, {"and", "this", "is", "another", "paragraph."}}
    ```
- [x] Automatic word wrapping
- [x] Simulation mode: only determine width and height without rendering
- [x] Custom base text size
- [x] Variable text size:
    ```lua
    {{"Individual", "words", "can", "be", {word="bigger", size=200}, "or", {word="smaller", size=50}, {word=".", space_before=false}}}
    ```
- [x] Text colors and opacity
- [x] Specify bounds for the text area
- [x] Horizontal alignment (left, center, or right)
- [x] Vertical alignment (top, middle, or bottom)
- [ ] [Fallback to a different font if the main font doesn't have the glyph](https://github.com/dividuum/info-beamer/issues/73)
- [ ] Custom word separators, maybe-breaks, and hyphenation
- [ ] Custom emoji
- [ ] Unicode emoji
- [x] Bold and italic text (via per-call or per-word font overrides)
- [ ] Underlines and strikethroughs
- [ ] Plugin support (render things like images inline)
