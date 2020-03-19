function data = getinfections(countryname, zonename)
% given the country name and zone name, get the infections data

thetable = readtable('time_series_19-covid-Confirmed.csv','HeaderLines',1);
countries = thetable(:,2);

countriecell = table2cell(countries);
zonecell = table2cell(thetable(:,1));
myzones = {};
for i = 1:length(countriecell)
    country = countriecell{i};
    zone = zonecell{i};
    if strcmp(string(country),countryname) && strcmp(string(zone),zonename)
        country_id = i;
    end
end

%%

data = thetable(country_id,5:end); % this is the infection data
data = table2array(data);

