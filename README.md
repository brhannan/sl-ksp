# KSP Toolbox
Control a rocket in Kerbal Space Program from Simulink.

KSP Toolbox provides Simulink blocks that allow Simulink to to communicate with KSP.

<p float = "left">
    <img src="doc/images/slkspsidebyside.png" width = "800"/>
</p>


## Highlights

KSP Toolbox provices Simulink / Kerbal Space Program cosimulation.

The goal of this project is to allow for controls and optical navigation
algorithms (which may be written in MATLAB, Python, C, C++, or Simulink)
to be tested in Kerbal Space Program.

## Dependencies
Kerbal Space Program 1.5.1  
[kRPC 0.4.8](https://krpc.github.io/krpc)  
MATLAB R2020b  
Simulink    
Python 3.x  
Stateflow (required to simulate example models)


## Setup

### KSP Toolbox setup
Download the toolbox installer at /release/KSPToolbox.mltbx to any location on your machine.  
Double-click this file to install KSP Toolbox.  

### kRPC setup
Follow the kRPC setup instructions given in this video:
[OS X](https://www.youtube.com/watch?v=x6wdnge-hZU&t=0s),
[PC](https://www.youtube.com/watch?v=RQzWri_K_UY).  

Basically, the steps in the video above are (assuming you already have
Python 3 up and running):  
- Install KSP v1.5.1 using steam (right-click Kerbal Space Program, go to
Properties -> Betas).  
- Download the KSP [kRPC mod](https://spacedock.info/mod/69/kRPC).  
- Copy the kRPC folder from this download to the KSP GameData folder (find
it by right-clicking Kerbal Space Program in Steam and go to Manage ->
Browse local files).  

### MATLAB Python path

See 
(this doc page)
[https://www.mathworks.com/help/matlab/matlab_external/
get-started-with-matlab-engine-for-python.html]. 

Follow the instructions on this page to get MATLAB and Python talking to 
each other.  Open MATLAB and enter the command 
```py.print("hello world")``` in the Command Window to confirm that the 
setup was successful. 

The KSP Toolbox Simulink blocks are fundamentally written in Python, so 
make sure that MATLAB and Python are on speaking terms before proceeding.


## Run the example model

- Open example project Slksp.prj using the MATLAB command ```ksp.loadSuborbitalFlightExample```  
- Open KSP and put a rocket on the launch pad.
- If the kRPC server window does not appear in the KSP window, select the
icon marked in the image below.
- Press the Start server button.  

<p float = "left">
    <img src="doc/images/start-krpc-server-menu.png" width = "300"/>
</p>

- Simulate the model.
- Check the KSP window. Accept the kRPC connection request if a kRPC prompt
appears.  
- Press the Launch button in the Simulink model.  
- Watch the altimeter climb. Takeoff is automated, landing is left as an exercise for the reader. (Note to self: add lander logic.)  

## To do
- [x] Refactor TX, RX blocks so that they share one kRPC object.
- [ ] Retrieve images from KSP to use for navigation.
- [ ] Package as toolbox.
