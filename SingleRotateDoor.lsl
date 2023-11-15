/**
    @name: SingleRotateDoor
    @description: Open the door by direction of avatar

    @author: Zai Dium
    @version: 1
    @updated: "2023-11-15 14:42:44"
    @revision: 17
    @localfile: ?defaultpath\GameClub\?@name.lsl
    @license: MIT

    @ref:

    @notice:
*/
integer Direction = 1; //* -1 or 1
integer OpenAngle = 90; // Angular swing of the door, in degrees
float OpenTime = 5.0; // Amount of time before the door closes automatically, in seconds

// ===== Do not mess with anything below here unless you know what you are doing ============

rotation OriginalRot;
integer OpenDir;
integer IsClosed  = TRUE;

integer WhereAmI(vector AviPos) // Where is the av, relative to the door's default swing direction?
{
    vector Size = llList2Vector(llGetLinkPrimitiveParams(LINK_THIS,[PRIM_SIZE]),0);
    vector Pos = llGetPos();
    if (Size.x > Size.y)
    {
        return (AviPos.x > Pos.x);
    }
    else
    {
        return (AviPos.y > Pos.y);
    }
}

Close()
{
    // Now reverse the direction of OriginalRot and apply it....
    llSetLocalRot( OriginalRot * llGetLocalRot() );
    OriginalRot.s *= -OpenDir;
    IsClosed = TRUE;
    llSetTimerEvent(0.0);
}

Open(key id){
    if ( IsClosed )  //* If the door is closed ...
    {
        OpenDir = Direction;
        if (WhereAmI(llList2Vector(llGetObjectDetails(id, [OBJECT_POS]), 0))) // Where is the av, relative to the door's default swing direction?
        {
            OpenDir *= -1; //* Reverse the door's default opening direction
        }
        OriginalRot.s *= OpenDir; //* Use the direction
        llSetLocalRot( OriginalRot * llGetLocalRot() );
        OriginalRot.s *= -1;  //* And reverse direction again, ready for the return swing
        llSetTimerEvent(OpenTime);
        IsClosed = FALSE;
    }
}

default
{
    state_entry()
    {
        OriginalRot = llEuler2Rot( <0.0, 0.0, (float)OpenAngle * DEG_TO_RAD> );
    }

    touch_start(integer num_detected)
    {
        if (IsClosed)
            Open(llDetectedKey(0));
        else
            Close();
    }

    collision_start( integer num_detected )
    {
        Open(llDetectedKey(0));
    }

    timer()
    {
        Close();
    }
}
