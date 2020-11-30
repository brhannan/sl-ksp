#include <iostream>
#include <chrono>
#include <thread>
#include <krpc.hpp>
#include <krpc/services/krpc.hpp>
#include <krpc/services/space_center.hpp>

#include "slksp.hpp"

extern "C" int send_launch_cmd(void)
{
    // set up connection to krpc server
    krpc::Client conn = krpc::connect("Sub-orbital flight");
    krpc::services::KRPC krpc(&conn);
    krpc::services::SpaceCenter space_center(&conn);
    
    // get active vehicle
    auto vessel = space_center.active_vessel();
    
    // set heading and max throttle
    vessel.auto_pilot().target_pitch_and_heading(90, 90);
    vessel.auto_pilot().engage();
    vessel.control().set_throttle(1);
    std::this_thread::sleep_for(std::chrono::seconds(1));

    // send launch cmd
    std::cout << "Launch!" << std::endl;
    vessel.control().activate_next_stage();
    
    return 0;
};