function changementTeam()
    -- print("LE TEST EST LA PUTAIN !")
    -- print(net.ReadString())
    
    --GUIToggled = not GUIToggled --Souris libérée
        gui.EnableScreenClicker(true)
        
    if (not DermaImageButton:IsVisible() and not DermaImageButtonDroite:IsVisible()) then
        DermaImageButton = vgui.Create("DImageButton")
        DermaImageButton:SetPos(0, 0)
        DermaImageButton:SetSize(ScrW()/2, ScrH())
        DermaImageButton:SetImage("insurgent.png")
        --DermaImageButton:SizeToContents()
        DermaImageButton.DoClick = function()
            DermaImageButton:Remove()
            DermaImageButtonDroite:Remove()
            gui.EnableScreenClicker(false)
            
            net.Start("ChooseTeamMenu")
                net.WriteString("insurgent")
            net.SendToServer()
        end
        
        DermaImageButtonDroite = vgui.Create("DImageButton")
        DermaImageButtonDroite:SetPos(ScrW()/2, 0)
        DermaImageButtonDroite:SetSize(ScrW()/2, ScrH())
        DermaImageButtonDroite:SetImage("security.png")
        --DermaImageButtonDroite:SizeToContents()
        DermaImageButtonDroite.DoClick = function()
            DermaImageButton:Remove()
            DermaImageButtonDroite:Remove()
            gui.EnableScreenClicker(false)
            
            net.Start("ChooseTeamMenu")
                net.WriteString("security")
            net.SendToServer()
        end
    end
end

net.Receive("InitialSpawnMenu", function()
    changementTeam()
end)