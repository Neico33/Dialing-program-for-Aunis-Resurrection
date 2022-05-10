c = require("component")
e = require("event")
m = c.modem
s = c.stargate

t1 = {}
t2 = {"Andromeda", "Aquarius", "Aquila", "Aries", "Auriga", "Bootes", "Cancer", "Canis Minor", "Capricornus", "Centaurus", "Cetus", "Corona Australis", "Crater", "Equuleus", "Eridanus", "Gemini", "Hydra", "Leo Minor", "Leo", "Libra", "Lynx", "Microscopium", "Monoceros", "Norma", "Orion", "Pegasus", "Perseus", "Piscis", "Pisces Austrinus", "Point of origin", "Sagittarius", "Scorpius", "Sculptor", "Scutum", "Serpens Caput", "Sextans", "Taurus", "Triangulum", "Virgo"}
t3 = {"Abrin", "Acjesis", "Aldeni", "Alura", "Amiwill", "Arami", "Avoniv", "Aaxel", "Bydo", "Baselai", "Ca Po", "Danami", "Dawnre", "Earth", "Ecrumig", "Elenami", "Gilltin", "Hacemill", "Hamlinto", "Illume", "Laylox", "Lenchan", "Olavii", "Once El", "Poco Re", "Ramnon", "Recktic", "Robandus", "Roehi", "Salma", "Sandovi", "Setas", "Sibbron", "Subido", "Tahnan", "Zamilloz", "Zeo"}
t4 = {"G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12", "G13", "G14", "G15", "G16", "G17", "G18", "G19", "G20", "G21", "G22", "G23", "G24", "G25", "G26", "G27", "G28", "G29", "G30", "G31", "G32", "G33", "G34", "G35", "G36", } 

v7 = "%,"
v11 = "1234"
v12 = 5
v13 = 30
v16 = "dev"

a1 = "Wormhole in arrivo"
a2 = "Chevron è stato attivato dal DHD".
a3 = "La porta è chiusa"
a4 = "Il computer si riavvierà tra "
a5 = "secondi al riavvio"
a6 = "Il cancello si chiuderà tra "
a7 = " secondi"
a8 = "Materia in entrata/uscita"
a9 = "Si prega di inserire chevron (ad esempio: 1,2,3,4,5,6,7,8,9):"
a10 = "Divertiti a programmare".
a11 = "Attivare "

f1 = "Errore: lo stargate non può essere aperto"
f2 = "Errore: GateTyp non riconosciuto"



function Start()
  m.open(2)
  Incoming()
  Code()
  Dhd()
  Close()
  Open()
  Failed()
  Matter()
  Type()
end

function Incoming()
  e1 = e.listen("stargate_incoming_wormhole", function()
    e.cancel(e5)
    os.execute("/bin/clear.lua")
    print(a1)
    v9 = s.getIrisState()
    if v9 == "OPENED" then
      s.toggleIris()
    else
      if v9 == "OPENING" then
        repeat
          os.sleep(1)
        until s.getIrisState() == "OPENED"
      s.toggleIris()
      end
    end
  end)
end

function Code()
  e2 = e.listen("modem_message", function(_, _, _, _, _, v10)
    if v10 == v11 then
      v9 = s.getIrisState()
      if v9 == "CLOSED" then
        s.toggleIris()
      else
        if v9 == "CLOSING" then
          repeat
            os.sleep(1)
          until s.getIrisState() == "CLOSED"
          s.toggleIris()
        end
      end
    end
  end)
end

function Dhd()
  e3 = e.listen("stargate_dhd_chevron_engaged", function()
    os.execute("/bin/clear.lua")
    print("")
    print(a2)
    os.sleep(5)
    Reboot()
  end)
end

function Close()
  e4 = e.listen("stargate_wormhole_closed_fully", function()
    print(a3)
    while v12 > 0 do
      print(a4..v12..a5)
      os.sleep(1)
      v12 = v12 - 1
    end
    Reboot()
  end)
end

function Open()
  e5 = e.listen("stargate_wormhole_stabilized", function()
    v14 = v13 / 5 
    while v13 > 0 do
      print(a6..v13..a7)
      v13 = v13 - v14
      os.sleep(v14)
    end
    s.disengageGate()
  end)
end

function Failed()
  e6 = e.listen("stargate_failed", function()
    print(f1)
    os.sleep(2)
    Reboot()
  end)
end

function Matter()
  e6 = e.listen("stargate_traveler", function()
      print(a8)
  end)
end

function Type()
  v8 = s.getGateType()
  if v8 == "MILKYWAY" then
    Write(t2)
  else
    if v8 == "PEGASUS" then
      Write(t3)
    else
      if v8 == "UNIVERSE" then
        Write(t4)
      else
        print(f2)
      end
    end
  end
end

function Write(t2)
  for v3,v4 in ipairs(t2) do
    print(v3,v4)
  end
  print(a9)
  v5 = io.read()
  if v5 == v16 then
    print(a10)
  else
    for v6 in string.gmatch(v5,"([^"..v7.."]+)") do
      v6 = tonumber(v6)
      table.insert(t1,t2[v6])
    end
    Dial(t1)
  end
end

function Dial(t1)
  for v1,v2 in ipairs(t1) do
    print(a11..v2.." ...")
    s.engageSymbol(v2)
    e.pull("stargate_spin_chevron_engaged")
    os.sleep(0.5)
  end
  s.engageGate()
end

function Reboot()
  e.cancel(e1)
  e.cancel(e2)
  e.cancel(e3)
  e.cancel(e4)
  e.cancel(e5)
  e.cancel(e6)
  os.execute("/bin/reboot.lua")
end

Start()
