
```lua
-- Add this property to your joker
buttons = {
        { -- One object for each additional button

            get_styling = function(card) -- Styling information for the button. OPTIONAL
                return {
                    button_color = G.C.RED, -- Background color of the button
                    name = "Button", -- Text on the button
                    align = 'bmi', -- bmi = bottom-mid. others are a combination of two letters for horizontal and vertical alignment (bl,cl,tl|br,cr.tr)
                    offset = {x = 0, y = 0.35}, -- button offset relative to the card
                    font_color = G.C.WHITE -- Color of the text on the button
                }
            end,
            can_use = function(card) -- Called every frame to determine if the button should be disabled (greyed out) or enabled
                return true
            end,
            use = function(card) -- This function is called on button press 
                HAMOD.debug(inspect(card.ability.extra))
            end,
            is_visible = function(card) -- When a card is selected, this function is executed to determine if the button should be created
                return card.area ~= G.shop_jokers
            end,
            --[[ generate_ui = function(card) -- used to pass a fully custom button. Must return UIBox. Otherwise, a template is used with the information returned in get_styling

            end ]]

        },
        {
            get_styling = function(card) -- Styling information for the button. OPTIONAL
                return {
                    button_color = G.C.BLUE,
                    name = "Button2",
                    align = 'tl',
                    offset = {x = 0, y = 0.35},
                    font_color = G.C.WHITE
                }
            end,
            can_use = function(card) -- Called every frame to determine if the button should be disabled (greyed out) or enabled
                return true
            end,
            use = function(card) -- This function is called on button press 
                HAMOD.debug(inspect(card.ability.extra))
            end,
            is_visible = function(card) -- When a card is selected, this function is executed to determine if the button should be created.
                return card.area ~= G.shop_jokers
            end,
            --[[ generate_ui = function(card) -- used to pass a fully custom button. Must return UIBox. OPTIONAL

            end --]]
        }
    },
```
