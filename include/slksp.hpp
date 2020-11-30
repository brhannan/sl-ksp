#ifndef _SL_KSP_H_
#define _SL_KSP_H_

#include <iostream>
#include <chrono>
#include <thread>
#include <krpc.hpp>
#include <krpc/services/krpc.hpp>
#include <krpc/services/space_center.hpp>

// #include "rtwtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

int send_launch_cmd(void);

#ifdef __cplusplus
}
#endif

#endif // _SL_KSP_H_