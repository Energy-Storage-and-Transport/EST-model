close all;
figure;

Pcharge = 15*unit('kW');
Pdischarge = 5*unit('kW');
Tcharge = 3*unit("h");
Tstore  = 8*unit("h");
Tstar   = Tcharge + Tstore;
c = (1-aSupplyTransport)*(1-aInjection);
d = 1/((1-aDemandTransport)*(1-aExtraction));
Echarge = (1-exp(-bStorage*Tcharge))*c/bStorage*Pcharge;
Estore  = Echarge*exp(-bStorage*(Tstore));
texact = tout(1):((tout(end)-tout(1))/10000):tout(end);
for i=1:size(texact,2)
    if texact(i)<= Tcharge
        Eexact(i) = (1-exp(-bStorage*texact(i)))*c/bStorage*Pcharge;
    elseif texact(i)>=Tstar
        Eexact(i) = (exp(-bStorage*(texact(i)-Tstar))-1)*d/bStorage*Pdischarge + Estore*exp(-bStorage*(texact(i)-Tstar));
    else
        Eexact(i) = Echarge*exp(-bStorage*(texact(i)-Tcharge));
    end
end


%% Stored energy
plot(tout/unit("day"), EStorage/unit("J"));
hold on;
plot(texact/unit("day"), Eexact/unit("J"));
xlim([0 tout(end)/unit("day")]);
grid on;
title('Storage');
xlabel('Time [day]');
ylabel('Energy [J]');
legend("Simulink", "Exact");