resource.AddFile("music/export.mp3")
include("entities/props/fence.lua")
include("entities/props/fence2.lua")

local ExtraFilters = {"prop_vehicle_airboat", "prop_dynamic"}



local spawnrate = 0

include("entities/props/fence.lua")
include("entities/buggies/buggy1.lua")
include("entities/buggies/buggy2.lua")
include("entities/buggies/buggy3.lua")
include("entities/buggies/buggy4.lua")
include("entities/buggies/buggy5.lua")
include("entities/buggies/buggy6.lua")
include("entities/buggies/buggy7.lua")
include("entities/buggies/buggy8.lua")

function UpdateTimer( time )
		net.Start("race_timer")
		net.WriteInt( time, 10 )
		net.Broadcast()
end


function RoundStart()


	if ((#player.GetAll()) < 2) then
	
	PrintMessage(HUD_PRINTCENTER, "Not enough players in the game! Get some in here!" )

	return end
	
	local time = 30
	UpdateTimer(time)
	PrintMessage(HUD_PRINTCENTER, "Race starting in 30 seconds!" )
		
		timer.Create( "roundstart", 1, time, function()
		
		print("Time before match start: " .. time )
		time = time - 1
		
			local Alive = 0
		
			for k, v in pairs ( player.GetAll() ) do
				
				if (v:Alive() ) then
					v:SetHealth(100)
					Alive = Alive + 1
				end
				
			end
			
			if ( time <= 0) then
				
				raceactive = true
			
				net.Start("race_active")
					net.WriteBool( true )
				net.Broadcast()
				
				RoundEndCheck()
			return
			
			end
			UpdateTimer( time )
		end)
	

end



function RoundEndCheck()
	seconds = math.Clamp(20,0,20)
	netbool = false
	PrintMessage(HUD_PRINTCENTER,"RACE STARTED! Press F4 to quickly get in a car! Be fast, you only have 20 seconds!")
		timer.Create("10Seconds", 1, seconds, function()
			print(netbool)
			seconds = seconds - 1
			netbool = true
				net.Start("10secondInt")
				net.WriteInt(seconds,32)
				net.Broadcast()
					net.Start("10secondBool")
					net.WriteBool(netbool)
					net.Broadcast()
	
			if seconds == 4 then
			for k, v in pairs(ents.FindByName("Startbutton1")) do
				v:Fire("Use")
			end
			end

			if seconds == 0 then
				netbool = false
				timer.Remove("10Seconds")
				net.Start("10secondBool")
				net.WriteBool(netbool)
				net.Broadcast()
				
			end
	end)
 
	
	RunConsoleCommand( "r_spawn" )
	
	game.CleanUpMap(false, ExtraFilters  )
	
	for _, v in pairs(player.GetAll() ) do
			if ( v:Alive() ) then
				v:SetHealth(100)
			end
	
		time = 180
	if !netbool then
	if( raceactive == false ) then return end
	
	
	
		timer.Create( "checkdelay", 1, time, function()
			local racersAlive = 0
			
			time = time - 1
			UpdateTimer( time )
			
			for k, v in pairs( team.GetPlayers( 0 ) ) do
				
				if (v:Alive() ) then
					racersAlive = racersAlive + 1
				end
				
				if (racersAlive == 0 ) then
				EndRound("All racers dead: Nobody")
			end
			end
			
			if time == 0 then
			EndRound("Time Ran Out! Nobody")
			end
		end)
	end
end
end



function EndRound(winners)
	PrintMessage(HUD_PRINTCENTER, winners .. " won the race! New one starting soon..." )

	num = 1
	
	for _, v in pairs(player.GetAll() ) do
			if (v:Alive() and v:InVehicle()) then
			
			local car = v:GetVehicle()
			if IsValid(car) then
			local vehicleclass = car:GetClass()
			
				if (vehicleclass != "prop_vehicle_airboat") then
				v:StripWeapons()
				v:Kill()
				v:SetFrags( v:Frags() + 1 )
				end
				end
			end
	timer.Remove("checkdelay")
	timer.Create( "cleanup", 3, 1, function()
		game.CleanUpMap(false, ExtraFilters )
	
		for _, v in pairs(player.GetAll() ) do
			if ( v:Alive() ) then
				v:StripWeapons()
				
			end
		
		v:SetGamemodeTeam(1) 
		
		end
		
		
		RoundStart()
		net.Start("race_active")
			net.WriteBool( false )
		net.Broadcast()
		raceactive = false
		SpawnFence()
		SpawnFence2()
		SpawnDemoDurbyFence1()
	SpawnDemoDurbyFence2()
	SpawnDemoDurbyFence3()
	SpawnDemoDurbyFence4()
	SpawnDemoDurbyFence5()
	SpawnDemoDurbyFence6()
	
	
	
	end)
end

end


function spawnRace( ply )

		if ply:Alive() then
			ply:SetGamemodeTeam(0)
			ply:SetPos(playerracespawn[spawnrate])
		
				if spawnrate == 8 then
					spawnrate  = 0
				else
					spawnrate = spawnrate + 1
				end
	
		end
	end
