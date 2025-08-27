function trigger_extra_buttons(card, is_highlighted)
    local btns = card.config.center.buttons
    if btns then
        if card.highlighted then
            local index = 0
            for _,btn in ipairs(btns) do
                if not btn.is_visible or type(btn.is_visible) ~= 'function' or btn.is_visible(card) then
                    local st = btn.get_styling and btn.get_styling(card) or {}
                    local offset = st.offset or {x=0.4,y=0}
                    local align = st.align or "cr"
                    card.children["extra_button"..index] = btn.generate_ui and btn.generate_ui(card) or UIBox{
                        definition = generate_extra_button(card, btn),
                        config = {align= align, offset = offset,
                            parent = card}
                    }
                    index = index + 1
                end
            end
        else
            for k,v in card.children do
                if string.sub(k, 1, #"extra_button") == "extra_button" then
                    v:remove()
                    v = nil
                end
            end
            
        end
    end
end

SMODS.DrawStep {
    key = 'tags_buttons_extra',
    order = -31,
    func = function(self)
        for k,v in pairs(self.children) do
            if string.sub(k, 1, #"extra_button") == "extra_button" then
                v:draw()
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

    t = {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={align = "cr"}, nodes={
      
      {n=G.UIT.C, config={ref_table = passingObj, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = button_color, one_press = false, button = 'use_extra', func = 'can_use_extra'}, nodes={
        --{n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.T, config={text = button_name,colour = font_color, scale = 0.55, shadow = true}}
      }}
    }}}}

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