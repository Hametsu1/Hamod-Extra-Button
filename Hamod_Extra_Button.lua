HAMOD_BUTTONS = {groups = {}}
function trigger_extra_buttons(card, is_highlighted)
    local btns = card.config.center.buttons
    if btns then
        if card.highlighted then
            HAMOD_BUTTONS.groups = {}
            for _,group in ipairs(btns.groups) do
                local group_name = group.name or 'extra'..#HAMOD_BUTTONS.groups
                if not HAMOD_BUTTONS.groups[group_name] then
                    HAMOD_BUTTONS.groups[group_name] = {
                        ui = 
                        {
                            n=G.UIT.ROOT,
                            config = {padding = 0, colour = G.C.CLEAR},
                            nodes={
                                {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={}}
                            }
                        },
                        styling = group.get_config and group.get_config(card) or {
                            align = 'cl',--((card.area == G.jokers) or (card.area == G.consumeables)) and "cr" or "bmi",
                            offset = {x = 0, y = 0},--((card.area == G.jokers) or (card.area == G.consumeables)) and {x = x_off - 0.4, y = 0} or {x = 0, y = 0.65},
                            parent = card
                        },
                        group = group
                    }
                    if not HAMOD_BUTTONS.groups[group_name].styling.parent then
                        HAMOD_BUTTONS.groups[group_name].styling.parent = card
                    end
                end

                for __,btn in ipairs(group.buttons) do
                    if not btn.is_visible or type(btn.is_visible) ~= 'function' or btn.is_visible(card) then
                        table.insert(
                            HAMOD_BUTTONS.groups[group_name].ui.nodes[1].nodes,
                            btn.generate_button and btn.generate_button(card) or generate_extra_button(card, btn)
                        )
                    end
                end
            end

            for k,v in pairs(HAMOD_BUTTONS.groups) do
                local uibox = v.group.generate_UIBox and v.group.generate_UIBox(card, v) or UIBox{
                    definition = v.ui,
                    config = v.styling
                }
                card.children[k] = uibox
            end
        else
            for k,v in pairs(HAMOD_BUTTONS.groups) do
                if card.children[k] then
                    card.children[k]:remove()
                    card.children[k] = nil
                end
            end
        end
    end
end

SMODS.DrawStep {
    key = 'tags_buttons_extra',
    order = -31,
    func = function(self)
        for k,v in pairs(HAMOD_BUTTONS.groups) do
            if self.children[k] then
                self.children[k]:draw()
            end
        end
    end,
} 

function generate_extra_button(card, btn)

    local passingObj = {
        card = card,
        button = btn
    }
    
    if not btn or not btn.use or type(btn.use) ~= 'function' then return nil end

    local style = btn.get_styling and btn.get_styling(card) or {}
    local button_name = style.name or 'Use'
    local font_color = style.font_color or G.C.WHITE
    local button_color = style.button_color or G.C.GREEN

    t = 
    {
        n=G.UIT.R, config={align = "cr"}, nodes=
            {
                {
                    n=G.UIT.C,
                    config=
                        {
                            ref_table = passingObj,
                            align = "cr",
                            maxw = 1.25,
                            padding = 0.1,
                            r=0.08,
                            minw = 1.25,
                            minh = (card.area and card.area.config.type == 'joker') and 0 or 1,
                            hover = true,
                            shadow = true,
                            colour = button_color,
                            one_press = false,
                            button = 'use_extra',
                            func = 'can_use_extra'
                        },
                    nodes=
                        {
                            {
                                n=G.UIT.T,
                                config=
                                    {
                                        text = button_name,
                                        colour = font_color,
                                        scale = 0.55,
                                        shadow = true
                                    }
                            }
                        }
                            
                }
            }
    }

    return t
end

G.FUNCS.can_use_extra = function(e)
    local c1 = e.config.ref_table
    local btn = c1.button
    local style = btn.get_styling and btn.get_styling(c1.card) or {}

    if not btn.can_use or btn.can_use(c1.card) then 
        e.config.colour = style.button_color or G.C.GREEN
        e.config.button = 'use_extra' 
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_extra = function(e)
    local c1 = e.config.ref_table
    c1.button.use(c1.card)
end