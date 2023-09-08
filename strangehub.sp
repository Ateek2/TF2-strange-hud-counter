#include <tf2>
#include <tf2_stocks>
#include <tf2attributes>


 
Handle handles[64];
 
public Plugin myinfo =
{
    name = "Strange kill hub",
    description = "Shows Strange Weapon kills in the hud",
    author = "Ilowayn",
    version = "1.0.0",
    url = ""
};
 
public void OnPluginStart()
{
    CreateTimer(0.5, CheckStrangeKills, _, 1);
}
 

public Action CheckStrangeKills(Handle timer)
{
    int i = 1;
    while (i <= MaxClients)
    {
        if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i))
        {
            if (handles[i])
            {
                ClearSyncHud(i, handles[i]);
            }
            else
            {
                Handle hHudText = CreateHudSynchronizer();
                handles[i] = hHudText;
            }
            int wep = GetEntPropEnt(i, Prop_Send, "m_hActiveWeapon");
            if (IsValidEntity(wep))
            {
                int attriblist[32];
                float valuelist[32] = 0.0;
                int count_static = TF2Attrib_GetSOCAttribs(wep, attriblist, valuelist);
                if (0 < count_static)
                {
                    int x;
                    while (x <= count_static)
                    {
                        if (attriblist[x] == 214)
                        {
                            ClearSyncHud(i, handles[i]);
                            SetHudTextParams(0.8, -0.4, 9999999.0, 0, 255, 0, 255, 0, 6.0, 0.1, 0.2);
                            char strangeKills[8192];
                            Format(strangeKills, 8192, "Strange Kill: %d", valuelist[x]);
                            ShowSyncHudText(i, handles[i], strangeKills);
                        }
                        x++;
                    }
                }
            }
        }
        i++;
    }
    return Plugin_Continue;
}

 