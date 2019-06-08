local GradientMat = Material("vgui/gradient_down")

function Las.UI.DrawHeader(text, font, w, h)
    surface.SetFont(font)
    for i=1,#text do
        surface.SetTextColor(HSVToColor(i + 5, 0.8, 1))
        local xpos = surface.GetTextSize(string.sub(text, 1, i-1))
        surface.SetTextPos(w + xpos, h)
        surface.DrawText(string.sub(text, i, i))
    end
end

function Las.UI.MakeButton(text, w, h, x, y, parent, callback)
    local button = vgui.Create("DButton", parent)
    button:SetPos(x, y)
    button:SetSize(w, h)
    button:SetText("")
    button.LerpR = 200
    button.LerpG = 100
    button.Paint = function(s, w, h)
        local backColor = Color(button.LerpR, button.LerpG, 0)
        if(s:IsHovered()) then
            button.LerpR = Lerp(0.1, button.LerpR, 255)
            button.LerpG = Lerp(0.1, button.LerpG, 200)
        else
            button.LerpR = Lerp(0.1, button.LerpR, 200)
            button.LerpG = Lerp(0.1, button.LerpG, 100)
        end
        draw.RoundedBox(0, 0, 0, w, h, backColor)
        surface.SetMaterial(GradientMat)
        surface.SetDrawColor(HSVToColor(0, 0.8, 1))
        surface.DrawTexturedRect(0, 0, w, h)
        draw.SimpleText(text, "las.ui.1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
    end
    if(callback) then
        button.DoClick = function()
            callback(button)
        end
    end
end

function Las.UI.MakeNavbarButton(text, w, h, parent, callback)
    local button = parent:Add("DButton")
    button:SetSize(w, h)
    button:Dock(TOP)
    button:SetText("")
    button.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 50))
        draw.SimpleText(text, "las.ui.1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
    end
    if(callback) then
        button.DoClick = function()
            callback(button)
        end
    end
end

net.Receive("las.core.openui", function()
    surface.CreateFont("las.ui.1", {
        font = "Roboto",
        size = ScrH() * 0.03
    })
    surface.CreateFont("las.ui.2", {
        font = "Roboto",
        size = ScrH() * 0.02
    })
    surface.CreateFont("las.ui.3", {
        font = "Roboto",
        size = ScrH() * 0.05
    })

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
    frame:SetPos(-frame:GetWide(), (ScrH() / 2) - (frame:GetTall() / 2))
    frame:MakePopup()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MoveTo((ScrW() / 2) - (frame:GetWide() / 2), (ScrH() / 2) - (frame:GetTall() / 2), 0.2)
    frame:SetDraggable(false)
    frame.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(5, 5, 5, 255))
        draw.RoundedBox(0, 0, 0, w, h * 0.01, Color(15, 15, 15, 255))
        draw.RoundedBox(0, 0, h * 0.01, w, h * 0.052, Color(15, 15, 15, 255))
        -- draw.RoundedBox(0, 0, 0, w * 0.1, h * 0.06, Color(255, 0, 0, 255))

        Las.UI.DrawHeader("Livaco's Admin System (LAS) - " .. Las.Build.Version .. " (" .. Las.Build.Revision .. ")", "las.ui.1", w * 0.01, h * 0.006)
    end
    local fw,fh = frame:GetSize()

    Las.UI.MakeButton("X", fw * 0.041, fh * 0.06, fw * 0.96, 0, frame, function(self)
        frame:Close()
    end)

    local selectedTab = "Home"

    local navbar = vgui.Create("DPanel", frame)
    navbar:SetPos(0, fh * 0.06)
    navbar:SetSize(fw * 0.2, fh * 0.949)
    navbar.selectHeight = 0
    navbar.selectLerp = 0
    navbar.Paint = function(s, w, h)
        navbar.selectLerp = Lerp(0.05, navbar.selectLerp, navbar.selectHeight)
        draw.RoundedBox(0, 0, 0, w, h, Color(15, 15, 15, 255))
        draw.RoundedBox(0, 0, navbar.selectLerp, w, h * 0.1, HSVToColor(25, 0.8, 1))
        surface.SetMaterial(GradientMat)
        surface.SetDrawColor(HSVToColor(0, 0.8, 1))
        surface.DrawTexturedRect(0, navbar.selectLerp, w, h * 0.1)
    end

    local space = navbar:GetTall() * 0.10106
    Las.UI.MakeNavbarButton("Home", navbar:GetWide(), space, navbar, function(self)
        local x,y = self:GetPos()
        navbar.selectHeight = y
    end)

    local masterPanel = vgui.Create("DPanel", frame)
    masterPanel:SetPos(fw * 0.2, fh * 0.06)
    masterPanel:SetSize(fw * 0.8, fh * 0.94)
    masterPanel.Paint = function(s, w, h)
        draw.SimpleText("The UI is a WIP. Please wait until a later verison.", "las.ui.1", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
    end
end)