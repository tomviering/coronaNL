function countriecell = getcountries()
% get all available countries

thetable = readtable('time_series_19-covid-Confirmed.csv','HeaderLines',1);
countries = thetable(:,2);

countriecell = table2cell(countries);
countriecell = unique(countriecell); 



