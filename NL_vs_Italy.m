%% get data
% get country indices
countries = getcountries('time_series_19-covid-Confirmed.csv',1,10000);

%% graph for NL
NL = 99;
countries(99,:)

data = getdata();

dataNL = data(99-1,:);
dataNL = table2array(dataNL);
dataNL = dataNL(40:end);

ypred = makegraph(dataNL);

xlabel('March')
title('Netherlands')

%% Make normal plot Netherlands

figure;
plot(dataNL);
hold on
plot(ypred(1:10))
legend('data','fit')

%% graph for Italy

Italy = 58;

data = getdata();
dataI = data(58-1,:); % subtract one because of the header
dataI = table2array(dataI);
% get to the exponential part:
dataI = dataI(9:end);
dataI = dataI(22:end);
dataI = dataI(4:end);

ypred = makegraph(dataI);

xlabel('Days (I dont know the dates here)')
title('Italy')

%% Make normal plot ITALY

figure;
plot(dataI);
hold on
plot(ypred)
legend('data','fit')
