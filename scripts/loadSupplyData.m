function Supply = loadSupplyData(supplyFile, timeUnit, supplyUnit)
% LOADSUPPLYDATA  Load the supply data from the specified file.
%   Supply = LOADSUPPLYDATA(supplyFile, supplyUnit) loads the
%   data in supplyFile with the time in timeUnit and the power in
%   supplyUnit, returning a time series.

    global unit;
    supply = importdata(supplyFile, ',');
    Supply = timeseries(unit(supplyUnit)*supply.data(:,2),unit(timeUnit)*supply.data(:,1));
end