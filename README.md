
```lua
HAMOD_BUTTONS.register_group({
    key = 'group1',
    get_config = function(card)
        return {
            offset = {x = 0.35, y = 0},
            align = 'cl'
        }
    end
})

HAMOD_BUTTONS.register_button({
    group = 'group1',
    can_use = function(card)
        return true
    end,
    use = function(card)
        print("Button pressed")
    end,
    get_styling = function(card)
        return {
            text_color = G.C.GOLD,
            height = 0,
            button_color = G.C.CHIPS
        }
    end
})

HAMOD_BUTTONS.register_button({
    group = 'group1',
    can_use = function(card)
        return true
    end,
    use = function(card)
        print("Button pressed")
    end,
    is_visible = function(card)
        return card.area == G.jokers
    end
})
```

**Group parameters**\
Required\
``key`` Identifier of the group\

Optional\
``get_config = function(card)`` Function to return the alignment and offset of the group
```lua
return {
    offset = {x = 0, y = 0}, -- Offset relative to the card object. Defauls to {x = 0.35, y = 0} for Jokers and {x = 0.5, y = 0} for Consumables
    align = '' -- Alignment relative to the card object. Defauls to 'cl' = center-left (tl,cl,bl,tr,cr,br,bmi)
}
```
``generate_UIBox = function(card, group_object)`` Function to return a custom UIBox, instead of using a template enriched with ``get_config``

**Button parameters**\
Required\
``can_use = function(card)`` Function to determine if the button should currently be enabled or disabled (greyed out). The game calls this every frame the button is visible
``use = function(card)`` Function to execute when the button is pressed

Optional\
``group`` Key of a registered group. Buttons in a group are positioned relative to each other. Defaults to ``'default'``
``is_visible = function(card)`` By default, every card will show this button in every context. Use this function, to limit this to certain types (Jokers, Consumables) or only in certain areas (G.jokers, G.shop_jokers)
``get_styling = function(card)`` Function to return styling information for the button
```lua
return {
    text = 'Use', -- Text that is displayed on the button
    font_color = G.C.WHITE, -- Color of the font
    text_align = 'cl', -- Alignment of the text within the button
    text_scale = 0.55, -- Size of the text
    button_color = G.C.GREEN, -- Color of the button
    height = 1, -- Height of the button. Min height is dependent on the padding
    width = 1.25, -- Width of the button. Min width is dependent on the padding
    padding = 0.1 -- Padding inside of the button
    rounding = 0.08, -- Rounding on the buttons corners
}
```
``generate_ui = function(card)`` Function to return a custom button ui, instead of using a template enriched with ``get_styling``
