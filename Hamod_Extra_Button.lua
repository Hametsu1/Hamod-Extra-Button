HAMOD_BUTTONS = {groups = {}, buttons = {}}

HAMOD_BUTTONS.register_group = function(args)
    if not args or not args.key then return end

    HAMOD_BUTTONS.groups[args.key] = args
end

HAMOD_BUTTONS.register_group({
    key = 'default'
})

HAMOD_BUTTONS.register_button = function(args)
    if not args or (not args.use or type(args.use) ~= 'function') or (not args.can_use or type(args.can_use) ~= 'function') then return end
    if not args.group then args.group = 'default' end

    table.insert(HAMOD_BUTTONS.buttons, args)
end

function starts_with(str, prefix)
    return str:sub(1, #prefix) == prefix
end

function trigger_extra_buttons(card, is_highlighted)
    local btns = HAMOD_BUTTONS.buttons
    local groups = HAMOD_BUTTONS.groups
    if btns then
        if card.highlighted then
            temp_groups = {}

            for _, btn in ipairs(btns) do
                if not btn.is_visible or type(btn.is_visible) ~= 'function' or btn.is_visible(card) then
                    local group_name = btn.group or 'default'
                    local group_object = groups[group_name] or {}

                    if not temp_groups[group_name] then
                        temp_groups[group_name] =
                        {
                            ui = 
                            {
                                n=G.UIT.ROOT,
                                config = {padding = 0, colour = G.C.CLEAR},
                                nodes={
                                    {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={}}
                                }
                            },
                            styling = group_object and group_object.get_config and group_object.get_config(card) or {
                                align = 'cl',--((card.area == G.jokers) or (card.area == G.consumeables)) and "cr" or "bmi",
                                offset = card.ability.consumeable and {x = 0.5, y = 0} or {x = 0.35, y = 0},--((card.area == G.jokers) or (card.area == G.consumeables)) and {x = x_off - 0.4, y = 0} or {x = 0, y = 0.65},
                                parent = card
                            },
                            group = group_object
                        }
                        if not temp_groups[group_name].styling.parent then
                            temp_groups[group_name].styling.parent = card
                        end
                    end
                    table.insert(
                        temp_groups[group_name].ui.nodes[1].nodes,
                        btn.generate_button and btn.generate_button(card) or generate_extra_button(card, btn)
                    )
                end
            end

            for k,v in pairs(temp_groups) do
                local uibox = UIBox{
                    definition = v.ui,
                    config = v.styling
                }
                card.children[v.group.overwrites or k] = uibox
            end

            -- Standalone button groups
            for k,v in pairs(HAMOD_BUTTONS.groups) do
                if not v.is_visible or (type(v.is_visible) == 'function' and v.is_visible(card)) then
                    if v.generate_UIBox and type(v.generate_UIBox) == 'function' then
                        card.children[v.overwrites or k] = v.generate_UIBox(card)
                    end
                end
            end
        else
            for k,v in pairs(card.children) do
                if HAMOD_BUTTONS.groups[k] then
                    v:remove()
                    v = nil
                end
            end
        end
    end
end

function is_extra_button(key)
    for k,v in pairs(HAMOD_BUTTONS.groups) do
        if k == key or (v.overwrites and v.overwrites == key) then
            return true
        end
    end
    return false
end

SMODS.DrawStep {
    key = 'tags_buttons_extra',
    order = -31,
    func = function(self)
        for k,v in pairs(self.children) do
            if HAMOD_BUTTONS.groups[k] then
                v:draw()
            end
        end
    end,
} 

function integrate_button(ui, btn, align)

    if align == 'bmi' then

    else

    end

end

function generate_extra_button(card, btn)

    local passingObj = {
        card = card,
        button = btn
    }
    
    if not btn or not btn.use or type(btn.use) ~= 'function' then return nil end

    local style = btn.get_styling and btn.get_styling(card) or {}
    local button_name = style.text or 'Use'
    local font_color = style.font_color or G.C.WHITE
    local button_color = style.button_color or G.C.GREEN
    local text_align = style.text_align or 'cl'
    local text_scale = style.text_scale or 0.55
    local height = style.height or 1
    local width = style.width or 1.25
    local rounding = style.rounding or 0.08
    local padding = style.padding or 0.1

    t = 
    {
        n=G.UIT.R, config={align = "cr"}, nodes=
            {
                {
                    n=G.UIT.C,
                    config=
                        {
                            ref_table = passingObj,
                            align = text_align,
                            maxw = width,
                            padding = padding,
                            r= rounding,
                            minw = width,
                            minh = height,
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
                                        scale = text_scale,
                                        shadow = true,
                                        align = text_align
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