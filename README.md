
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
