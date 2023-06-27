# EST-model
Simulink model for the Energy Storage and Transport project. This Simulink model contains a simplified version of a real-life Energy Storage and Transport system, which describes the flow of energy in such a system. A supporting MATLAB file is provided which can be used to predefine parameters and to post-process data into figures.

Each subsystem in the model can be described by the following set of equations

$$\dot{E}=P_{in}-P_{out}-D$$

where $\dot{E}$ is the change of total energy in the subsystem, $P_{in}$ the incoming power, $P_{out}$ the outgoing power and $D$ the dissipated energy which is described by

$$D=\beta E + \alpha \dot{E}$$

where $\alpha$ and $\beta$ are some dissipation coefficients and $E$ the total energy in the subsystem. As all the subsystems, except the storage containment system are flowing systems, there is no stored-up energy in them, meaning that the first term in the dissipated energy equation is neglected.

## Supply and Demand
The data sets provided in this repository (_DemandGroup00.csv_ and _SupplyGroup00.csv_) can be used to perform a unit test in the given model. Inside the MATLAB model, this data is converted to a .mat file, as this file type is compatible with Simulink. The .mat files are loaded into Simulink in the corresponding Supply and Demand Subsystems. Running the Simulink model with the files for the unit test should result in the graphs shown in Figure 1.

<img src="/Images/unit_test.png" width="600">

*Figure 1: Results of the unit test*

## Transport from supply
During transportation from the supply, the dissipated energy is given by

$$D_{Transport From Supply}=\alpha_{Transport From Supply} P_{From Supply}$$

the energy which isn't dissipated is then given by

$$P_{To Controller} = P_{From Supply} - D_{Transport From Supply}$$

## Transport to demand
During transportation to the demand, the dissipated energy is given by (Note, this is a reversed process as the demand is a known value)

$$D_{Transport To Demand}=\frac{\alpha_{Transport To Demand}}{1+\alpha_{Transport To Demand}} P_{To Demand}$$

the energy which has to be provided while taking the dissipated energy into a count is then given by

$$P_{From Controller} = P_{To Demand} - D_{Transport To Demand}$$

## Controller
The controller is the basis of the model, it determines if there is enough energy supplied to meet the demand by extracting extra energy from the storage containment system if needed or by selling/buying energy from the grid in the form of load balancing. Therefore, the power difference $\Delta_P$ between $P_{To Controller}$ and $P_{From Controller}$ is first calculated. Based on the sign of this difference the following two actions can take place;
* The sign is postive ($\Delta_P \geq 0$). If the storage system is not yet full, the power surplus is sent toward the storage system. If the storage system is full, the power surplus is sold to the grid. 
* The sign is negative ($\Delta_P < 0$). If the storage system is above the minimum energy level, the power deficit is extracted from the storage system. If the storage system is empty, the power deficit is bought from the grid.

## Storage containment system
The storage containment system can be described by three different subsystems; injection, storage and extraction. 

### Injection
During injection, the dissipated energy is given by

$$D_{Injection} = \alpha_{Injection}  P_{To Injection}$$

the energy which is then injected is given by

$$P_{To Storage} = P_{To Injection} - D_{Injection}$$

### Storage
During storing of the energy in the storage containment system, energy is injected and extracted. Some of the energy is also dissipated which can be described by

*Hier nog even goed naar kijken! Laatste term verandert in $P_{To Storage}+P_{From Storage}$, want anders is dissipation positief tijdens extractie.*
$$D_{Storage}=\beta_{Storage}\frac{1}{1+\alpha_{Storage}}(E_{Storage}-E_{Storage Min})+\frac{\alpha_{Storage}}{1+\alpha_{Storage}}(P_{To Storage}+P_{From Storage})$$

From this equation, it can be seen that for $\alpha &#8594 \infty$, the energy difference disappears and only the power term contributes to the dissipated energy. For $\alpha &#8594 0$, the power term disappears and only the energy difference contributes to the dissipated energy. The energy which is then actually injected or extracted is given by

$$\dot E_{Storage}=P_{To Storage}-P_{From Storage}-D_{Storage}$$

As energy is stored over time, the total energy in the storage containment system can be given by

$$E_{Storage}(t)=\int \dot E_{Storage}dt+E_{Storage}(0)$$

### Extraction
During extraction, the dissipated energy is given by

$$D_{Extraction}=\frac{\alpha_{Extraction}}{1+\alpha_{Extraction}} P_{From Extraction}$$

the energy which is then extracted is given by

$$P_{From Storage} = P_{From Extraction} + D_{Extraction}$$
