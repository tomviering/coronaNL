function y = getdata2(countryname)

thetable = readtable('time_series_19-covid-Confirmed.csv','HeaderLines',1);
countries = thetable(:,2);

countriecell = table2cell(countries);
for i = 1:length(countriecell)
    country = countriecell{i};
    if strcmp(string(country),countryname)
        NL = i;
    end
end

%%

dataNL = thetable(NL,5:end);
dataNL = table2array(dataNL);
dataNL = dataNL(1:end); % only get march
y = dataNL;