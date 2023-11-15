/**
    @name: DoubleSlideDoor
    @description:
    @author: Zai Dium
    @updated: "2023-11-15 14:42:42"
    @localfile: ?defaultpath\GameClub\?@name.lsl
    @version: 1
    @revision: 88
    @license: MIT

    @ref:

    @notice:
*/

//* Setting, you can change it
float sensor_range = 5; //* auto open when avi detected in 3 meters, 0 for off
float sensor_interval = 2; //*

switchState(){
    llMessageLinked(LINK_ALL_CHILDREN, 0, "switch", "");
}

changeState(integer open){
    if (open) {
        llMessageLinked(LINK_ALL_CHILDREN, 0, "open", "");
    }
    else {
        llMessageLinked(LINK_ALL_CHILDREN, 0, "close", "");
    }
}

default
{
    state_entry()
    {
        if (sensor_range > 0)
            llSensorRepeat("", NULL_KEY, AGENT, sensor_range, PI, sensor_interval);
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

    sensor( integer number_detected )
    {
        if (number_detected > 0)
            changeState(TRUE);
    }

    touch_start(integer num_detected)
    {
        switchState();
    }
}
