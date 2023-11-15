/**
    @name: SingleSlideDoor
    @description:
    @author: Zai Dium
    @updated: "2023-11-15 14:42:20"
    @localfile: ?defaultpath\GameClub\?@name.lsl
    @version: 1
    @revision: 77
    @license: MIT

    @ref:

    @notice:
*/

//* Setting, you can change it
integer Direction = -1; //* -1,1
float sensor_range = 3; //* auto open when avi detected in 3 meters, 0 for off
float timeout = 5; //* seconds before auto close
string sound = "slideopendoor";

//*-------------------------------

setAs(integer open) {
    llSetObjectDesc((string)open);
}

integer getIsOpen() {
    list param = llParseString2List(llGetObjectDesc(),[","],[""]);
    return llList2Integer(param, 0);
}

changeState(integer open, integer notify){
    integer is_open = getIsOpen();
    if (is_open != open)
    {
        llTriggerSound(sound, 1.0);
        vector size = llGetScale();
        float width;
        if (size.y > size.x)
            width = size.y;
        else
            width = size.x;

        integer times = 1;
        integer i = times;
        while(i > 0) {
            llSetPos(llGetLocalPos() + <0.0, Direction * (open * 2 - 1) * (width / times), 0.0>);
            llSleep(0.5);
            i--;
        }
        setAs(open);
        if (notify)
            llMessageLinked(LINK_ALL_OTHERS, open, llGetObjectName(), llGetKey());
    }
    if (open)
        llSetTimerEvent(timeout);
    else
        llSetTimerEvent(0);
}

switchState(){
    integer open = getIsOpen();
    open = !open;
    changeState(open, TRUE);
}

default
{
    state_entry()
    {
        if (sensor_range > 0)
            llSensorRepeat("", NULL_KEY, AGENT, sensor_range, PI, 2);
    }

    on_rez(integer start_param )
    {
        llResetScript();
    }

    changed (integer change)
    {
        if ((change & CHANGED_REGION_START) || (change & CHANGED_OWNER)) {
            llResetScript();
        }
    }

    link_message( integer sender_num, integer num, string message, key id )
    {
        if (message==llGetObjectName() && id != llGetKey())
        {
            changeState(num, FALSE);
        }
    }

    sensor( integer number_detected )
    {
        if (number_detected>0)
            changeState(TRUE, FALSE);
    }

    touch_start(integer num_detected)
    {
        //key toucher_id = llDetectedKey(0);
        switchState();
    }

    timer()
    {
        changeState(FALSE, FALSE);
        llSetTimerEvent(0);
    }
}
