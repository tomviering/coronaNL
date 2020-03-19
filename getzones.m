function myzones = getzones(countryname)
% get the zones for a country

thetable = readtable('time_series_19-covid-Confirmed.csv','HeaderLines',1);
countries = thetable(:,2);

countriecell = table2cell(countries);
zonecell = table2cell(thetable(:,1));
myzones = {};
for i = 1:length(countriecell)
    country = countriecell{i};
    zone = zonecell{i};
    if strcmp(string(country),countryname)
        myzones{end+1} = zone;
    end
end

end