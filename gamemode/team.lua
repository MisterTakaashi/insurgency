/////////////////////////////////////////////////////
//                                                 //
//                      TEAMS                      //
//                                                 //
/////////////////////////////////////////////////////

// Deux equipes de bases > 1 & 2

team.SetUp(1, "Insurgent", Color(255, 0, 0))
team.SetUp(2, "Security", Color(0, 0, 255))

// Classes suivant les equipes
// Classes des insurges

team.SetUp(11, "Soldat", Color(255, 0, 0))

// Classes des security

team.SetUp(21, "Agent", Color(0, 0, 255))

/////////////////////////////////////////////////////
//                                                 //
//                 COMMANDES TEAMS                 //
//                                                 //
/////////////////////////////////////////////////////

concommand.Add("changeteam", function(ply, cmd, args)
    if ply:IsAdmin() then
        ply:SetTeam(tonumber(args[1]))
        print("Votre équipe a été changée.")
        ply:Spawn()
    else
        ply:PrintMessage(HUD_PRINTTALK, "Vous devez être administrateur pour faire cette action !")
    end
end)