# KSP Toolbox
Control a rocket in Kerbal Space Program from Simulink.

KSP Toolbox provides Simulink blocks that allow Simulink to to communicate with KSP.

<p float = "left">
    <img src="doc/images/slkspsidebyside.png" width = "800"/>
</p>


## Highlights

KSP Toolbox enables cosimulation with Simulink and Kerbal Space Program .

The goal of this project is to allow for controls and optical navigation
algorithms (which may be written in MATLAB, Python, C, C++, or Simulink)
to be tested in Kerbal Space Program.

This provides
- multidomain simulation capabilities, 
- the coolest flight simulation visualization capabilities period, 
- and interesting engineering analyses for KSP missions.

## Dependencies
Kerbal Space Program 1.5.1  
[kRPC 0.4.8](https://krpc.github.io/krpc)  
MATLAB R2020b  
Simulink    
Python 3.x  
Stateflow (required to simulate example models)


## Setup

### Install KSP Toolbox
- Download the toolbox installer at 
[/release/KSPToolbox.mltbx](https://github.com/brhannan/sl-ksp/tree/main/release) 
to any location on your machine.  
- Open MATLAB and navigate to the folder that KSPToolbox.mltbx was downloaded to.  
- Double-click KSPToolbox.mltbx in the MATLAB Current Folder window to 
install KSP Toolbox.  

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
[this doc page](https://www.mathworks.com/help/matlab/matlab_external/get-started-with-matlab-engine-for-python.html) 
for instructions that will allow you to use Python commands in MATLAB.

Open MATLAB and enter the command 
```py.print("hello world")``` in the Command Window to confirm that the 
setup was successful. 

The KSP Toolbox Simulink blocks use the Python kRPC API, so 
make sure that MATLAB and Python are on speaking terms before proceeding.


## Run the example model

- Open an example project using the MATLAB command ```ksp.loadSuborbitalFlightExample```  
- Open KSP and put any rocket on the pad.  
- If the kRPC server window doesn't automatically appear in the KSP window, 
select the button shown by the red arrow in the image below. Press the 
Start server button.  

<p float = "left">
    <img src="doc/images/start-krpc-server-menu.png" width = "300"/>
</p>

- Simulate the model.
- Check the KSP window. Accept the kRPC connection request if a kRPC prompt
appears.  
- Go back to the Simulink window and press the Launch button.  
- Watch the altimeter climb. Landing is left as an exercise for the reader.  


## Creating custom models with KSP Toolbox blocks

Follow the steps below to create a new model using KSP Toolbox blocks.
- Create a new Simulink model.
- Select a fixed-step solver. The example model uses a solver step size of 0.1.
- Enter the command ```ksplib``` to open the KSP Toolbox library.
- Copy a KSPServer block, a ToKSP block, and a FromKSP block to the model.
- The ToKSP and FromKSP blocks require specific bus objects. Create these 
bus objects using the 
```[kspTxIn,control,autopilot] = ksp.bus.getTxInput()``` 
and 
```[kspRxOut,vesselRx,flight] = ksp.bus.getRxOutput()``` 
commands. See the command-line help of each function for more info.


## To do
- [x] Refactor TX, RX blocks so that they share one kRPC object.
- [x] Package as toolbox.
- [ ] Add to the list of signals obtained from KSP in bus kspRxOut.
- [ ] Add test suite.
- [ ] Add HTML block documentation.
- [ ] Add image capture tools for optical nav simulation.
