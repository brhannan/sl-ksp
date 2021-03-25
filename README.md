# KSP Toolbox

KSP Toolbox provides Simulink blocks and MATLAB functions that can be used to
control a rocket in Kerbal Space Program from Simulink.

![](https://github.com/brhannan/sl-ksp/blob/main/doc/images/ksplaunchdemo2.gif)


## Highlights

KSP Toolbox enables cosimulation with Simulink and Kerbal Space Program.

The goal of this project is to allow for controls and optical navigation
algorithms (which may be written in C, C++, Python, MATLAB, or Simulink)
to be tested in Kerbal Space Program.

KSP Toolbox provies
- multidomain simulation capabilities (controls, vision, comms, ...),  
- the coolest flight simulation visualization capabilities, period,
- and turbocharged engineering analysis capabilities for KSP missions.

## Dependencies
Kerbal Space Program 1.5.1  
[kRPC 0.4.8](https://krpc.github.io/krpc)  
MATLAB R2020b  
Simulink    
Python 3.x  
Stateflow (required to simulate example models)


## Setup

### Install KSP Toolbox
- Get the toolbox installer at
[/release/KSPToolbox.mltbx](https://github.com/brhannan/sl-ksp/tree/main/release)
to any location on your machine.  
- Open MATLAB and navigate to the folder that KSPToolbox.mltbx was
downloaded to.  
- Double-click KSPToolbox.mltbx in the MATLAB Current Folder window to
install KSP Toolbox.  

### Get the kprc Python module
Open a terminal and use the command ```pip install krpc``` to install krpc.
See full instructions
[here](https://krpc.github.io/krpc/getting-started.html).

### Get the kRPC mod
Follow the kRPC setup instructions given in this video:
[OS X](https://www.youtube.com/watch?v=x6wdnge-hZU&t=0s),
[PC](https://www.youtube.com/watch?v=RQzWri_K_UY).  

Basically, the steps in the video above are (assuming you already have
Python 3 up and running):  
- Install KSP v1.5.1 using Steam. Open Steam, right-click Kerbal Space Program,
go to Properties -> Betas and select v1.5.1).  
- Download the KSP [kRPC mod](https://spacedock.info/mod/69/kRPC).  
- Copy the kRPC folder downloaded in the step above to the KSP GameData folder
(find it by right-clicking Kerbal Space Program in Steam and go to Manage ->
Browse local files).  

### Check the MATLAB Python path

See
[this doc page](https://www.mathworks.com/help/matlab/call-python-libraries.html)
for instructions that will let you use Python commands in MATLAB.

Open MATLAB and enter the command
```py.print("hello world")``` in the Command Window to confirm that the
setup was successful. The KSP Toolbox Simulink blocks use the Python kRPC
API, so make sure that MATLAB and Python are on speaking terms before
proceeding.


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


## Creating custom models with KSP Toolbox

Use the command ```ksp.createNewModel``` to open a template KSP Toolbox
model.

Alternatively, follow the steps below to manually create a new model using
KSP Toolbox blocks.
- Create a new Simulink model.
- Select a fixed-step solver. The example model uses a solver step size of 0.1.
- Enter the command ```ksplib``` to open the KSP Toolbox library.
- Copy a KSPServer block, a ToKSP block, and a FromKSP block to the model.
- The ToKSP and FromKSP blocks require specific bus objects. Create these
bus objects using the
```ksp.bus.getAll```
command. See this function's command-line help for more info.


## Troubleshooting

If you see an "Unable to resolve the name py.slksp.SLKSPMessenger" error,
try the following.
- Enter the command ```ksp.addSrcToPythonPath``` and simulate again.
- Enter the command ```ver``` and ensure that KSP Toolbox is on the list
of installed products. If it isn't, see the install steps above.
- See [this doc page](https://www.mathworks.com/help/matlab/matlab_external/undefined-variable-py-or-function-py-command.html)
for debugging steps.
- Check that you are able to import krpc in a Python prompt (not MATLAB).
If this doesn't work, see the kRPC installation link above.


## To do
- [x] Refactor TX, RX blocks so that they share one kRPC object.
- [x] Package as toolbox.
- [ ] Add function signatures JSON.
- [ ] Add to the list of signals obtained from KSP in bus kspRxOut.
- [ ] Add test suite.
- [ ] Add HTML block documentation.
- [ ] Add image capture tools for optical nav simulation.


## License

Copyright 2020, Brian Hannan. Released under the
[MIT License](https://github.com/brhannan/sl-ksp/blob/main/LICENSE).
