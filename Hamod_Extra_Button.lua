function generate_extra_button(card)
    local btn = card.config.center.button
    local _card = card
    _card.ability = card.config.center.config
    if not btn or not btn.use or type(btn.use) ~= 'function' then return nil end
    if btn.is_visible and type(btn.is_visible) == 'function' and not btn.is_visible(card, card.area) then return nil end

    
    if btn.generate_ui and type(btn.generate_ui) == 'function' then return btn.generate_ui(card, card.area) end

    local style = btn.get_style and btn.get_style() or {}
    local button_name = style.name or 'Use'
    local font_color = style.font_color or G.C.WHITE
    local button_color = style.button_color or G.C.GREEN

    t = {n=G.UIT.C, config={align = "cr"}, nodes={
      
      {n=G.UIT.C, config={ref_table = _card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = button_color, one_press = false, button = 'use_extra', func = 'can_use_extra'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.T, config={text = button_name,colour = font_color, scale = 0.55, shadow = true}}
      }}
    }}

    return t
end

G.FUNCS.can_use_extra = function(e)
    local c1 = e.config.ref_table
    local btn = c1.config.center.button or {}
    local style = btn.get_style and btn.get_style() or {}

    if not btn.can_use or btn.can_use(c1, c1.area) then 
        e.config.colour = style.button_color or G.C.GREEN
        e.config.button = 'use_extra' 
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.use_extra = function(e)
    local c1 = e.config.ref_table
    c1.config.center.button.use(c1, c1.area)
end