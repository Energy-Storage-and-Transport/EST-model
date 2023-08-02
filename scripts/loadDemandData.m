function Demand = loadDemandData(demandFile, timeUnit, demandUnit)
%   LOADDEMANDDATA  Load the demand data from the specified file.
%   Demand = LOADDEMANDDATA(demandFile, timeUnit, demandUnit) loads the
%   data in demandFile with the time in timeUnit and the power in
%   demandUnit, returning a time series.

    global unit;
    demand = importdata(demandFile, ',');
    Demand = timeseries(unit(demandUnit)*demand.data(:,2),unit(timeUnit)*demand.data(:,1));
end