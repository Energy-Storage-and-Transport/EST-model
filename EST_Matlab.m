clear all; close all; clc;
%% Data importation
T=365*24*60*60;                             % Amount of seconds in a year
YourGroupNumber = '00';                     % Your group number ex. '01'; Use '00' for sample data

Data.Supply_Data_Temp = importdata(fullfile(['SupplyGroup',YourGroupNumber,'.csv']));
Data.Supply_Data = Data.Supply_Data_Temp.data;
Supply_Time_series = timeseries(Data.Supply_Data(:,2),Data.Supply_Data(:,1)*60);
save('supply.mat','Supply_Time_series', '-v7.3');

Data.Demand_Data_Temp = importdata(fullfile(['DemandGroup',YourGroupNumber,'.csv']));
Data.Demand_Data = Data.Demand_Data_Temp.data;
Demand_Time_series = timeseries(Data.Demand_Data(:,2),Data.Demand_Data(:,1)*60);
save('demand.mat','Demand_Time_series', '-v7.3');

%% Defining parameters (As an example, change them to be compatible with your storage system)
MWh = 3.6e3;                            % Megajoule per megawatt-hour                           [h]
E_storage_max = 5e5*MWh;                % Maximum energy in storage                             [MJ]
E_storage_min = 0;                      % Minimum energy in storage                             [MJ]
E_initial = 0.0*E_storage_max;          % Initial energy in storage                             [MJ]
alpha_storage = 0.1;                    % Storage alpha dissipation coefficent                  [-]
beta_storage = 1e-8;                    % Storage beta dissipation coefficient                  [-]
alpha_transport_from_supply = 0.1;      % Transport from supply alpha dissipation coefficent    [-]
alpha_transport_to_demand = 0.1;        % Transport to demand alpha dissipation coefficent      [-]
alpha_injection = 0.1;                  % Insertion alpha dissipation coefficent                [-]
alpha_extraction = 0.1;                 % Extraction alpha dissipation coefficent               [-]

%% Plotting
close all;
sim EST_Simulink.slx                                                % File name of the Simulink model (In same folder!)

Length_idx = round(length(tout)/365);
Starting_date = 1;                                                  % Starting date to plot figures
Starting_date_idx = round(length(tout)/365*(Starting_date))+1;      % Index of starting date to plot figures
Ending_date = 365;                                                  % Ending date to plot figures
Ending_date_idx = round(length(tout)/365*(Ending_date));            % Index of ending date to plot figures
t=1:1:365;                                                          % Array with every day of the year

for i=1:length(t)                                                   % Loop to sum energy over the complete day
Supply_day(i) = sum(Supply(round((i-1)*length(tout)/365)+1:round((i-1)*length(tout)/365+length(tout)/365)))*24*60*60/Length_idx;
Demand_day(i) = sum(Demand(round((i-1)*length(tout)/365)+1:round((i-1)*length(tout)/365+length(tout)/365)))*24*60*60/Length_idx;
Sell_day(i) = sum(Sell(round((i-1)*length(tout)/365)+1:round((i-1)*length(tout)/365+length(tout)/365)))*24*60*60/Length_idx;
Buy_day(i) = sum(Buy(round((i-1)*length(tout)/365)+1:round((i-1)*length(tout)/365+length(tout)/365)))*24*60*60/Length_idx;
Dissipated_energy_day(i) = sum(Dissipated_energy(round((i-1)*length(tout)/365)+1:round((i-1)*length(tout)/365+length(tout)/365)))*24*60*60/Length_idx;
end

% Supply and Demand every day
figure('Renderer', 'painters', 'Position', [200 200 900 600])
subplot(2,2,1)
plot(t(Starting_date:Ending_date),Supply_day(Starting_date:Ending_date)/MWh/1e3)
hold on
plot(t(Starting_date:Ending_date),Demand_day(Starting_date:Ending_date)/MWh/1e3)
xlim([Starting_date Ending_date])
grid on
legend('Supply','Demand')
xlabel('Time [Day]')
ylabel('Energy [GWh]')
title('Supplied and demanded energy every day')

% Stored energy
subplot(2,2,2)
plot(tout(Starting_date_idx:Ending_date_idx)/1440/60,Stored_energy(Starting_date_idx:Ending_date_idx)/MWh/1e3)
xlim([Starting_date Ending_date])
ylim([0 ceil(max(Stored_energy)/MWh/1e3/10)*10])
grid on
xlabel('Time [Day]')
ylabel('Energy [GWh]')
title('Total energy in the storage containment system')

% Sold and bought energy every day
subplot(2,2,3)
plot(t(Starting_date:Ending_date),Sell_day(Starting_date:Ending_date)/MWh/1e3)
hold on
plot(t(Starting_date:Ending_date),Buy_day(Starting_date:Ending_date)/MWh/1e3)
xlim([Starting_date Ending_date])
grid on
legend('Sold','Bought')
xlabel('Time [Day]')
ylabel('Energy [GWh]')
title('Sold and bought energy every day')

% Dissipated energy every day
subplot(2,2,4)
plot(t(Starting_date:Ending_date),Dissipated_energy_day(Starting_date:Ending_date)/MWh/1e3)
xlim([Starting_date Ending_date])
ylim([0 ceil(max(Dissipated_energy_day)/MWh/1e3)])
grid on
xlabel('Time [Day]')
ylabel('Energy [GWh]')
title('Dissipated energy every day')
