clear all;
close all;
clc;

markersize = 20;
linewidth = 2;

%% Download the data
% this dataset is updated every day for all countries

url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv';
fn = 'time_series_19-covid-Confirmed.csv';
websave(fn, url);

%% List all available countries

countries = getcountries();
countries

%% Get the zones

country = 'Netherlands'; % country for which we want to fit
fprintf('For the country %s the following zones are available:\n', country);
zones = getzones('Netherlands') % what zones are there?
% put the zone you want to fit in 'zone' below

%% Get the data

zone = 'Netherlands';

y = getinfections(country, zone);
offset = 40; % start plots from march 1
y = y(offset:end); % only march
t = 1:length(y); % time in days from March

%% Make figure with data

figure;
plot(t,y,'.','MarkerSize',markersize,'DisplayName',country);
hold on;

grid on
title(sprintf('Corona in %s',country))
xlabel('March')
ylabel('Positive Test Results')
legend('Location','NorthWest');

%% Compute exponential fit using least squares

skip = 5; % do not fit first 5 days
maxt = 20; % until when to predict

t = t(skip:end);
y = y(skip:end);

X = [t',ones(size(t'))]; % the input variable (time, offset)
Y = log10(y'); % convert to logscale and do fit there

beta = inv(X'*X)*X'*Y; % least square fit

tfar = [(1:maxt)',ones(maxt,1)]; % what dates to predict
ypred_logscale = tfar*beta; % compute predictions in logscale
ypred = 10.^ypred_logscale; % convert back to normal scale

%% Figure with least squares fit

figure;
hold on;
plot(1:maxt,ypred,'DisplayName','Least Squares Fit','LineWidth',linewidth);
plot(t,y,'.','MarkerSize',markersize,'DisplayName',country);

grid on
title(sprintf('Corona in %s',country))
xlabel('March')
ylabel('Positive Test Results')
legend('Location','NorthWest');

%% Compute growth factors and display fit information

A = 10.^beta(1);
C = 10.^beta(2);
the_function = A.^tfar(:,1) * C; % recompute predictions
% observe that ypred = the_function, thus the formula is indeed correct

%% Robust fit using previous one as initialization

x = t;
ft = fittype( 'A * C^x', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'iter';
opts.Algorithm = 'Levenberg-Marquardt';
%opts.Robust = 'LAR';

opts.StartPoint = [C A];
% Fit model to data.
[fitresult, gof] = fit(x', y', ft, opts);

%% Plot robust fit

figure;
hold on;
plot(tfar(:,1),feval(fitresult,tfar(:,1)),'DisplayName','Robust fit','LineWidth',linewidth);
plot(t,y,'.','MarkerSize',markersize,'DisplayName',country);

grid on
title(sprintf('Corona in %s',country))
xlabel('March')
ylabel('Positive Test Results')
legend('Location','NorthWest');

%% Get growth factors

A = fitresult.A;
C = fitresult.C;

clc;
fprintf('y = A C^t\n');
fprintf('where t is the day in March\n');
fprintf('A = %g\n',A);
fprintf('C = %g\n',C);
fprintf('every %.1f days the amount of infections grows by a factor 10\n',log(10)/log(C))
fprintf('every %.1f days the amount of infections grows by a factor 2\n',log(2)/log(C))

%% Compare with Italy

y_italy = getinfections('Italy','');

offset = 40; % this is march 1
timeshift = 12; % delay time series by 12 days
until_date = 40-timeshift+max(t); % plot until current date

y_italy_plot = y_italy((offset-timeshift):until_date);

figure;
hold on;
plot(tfar(:,1),feval(fitresult,tfar(:,1)),'DisplayName','Robust fit','LineWidth',linewidth)
plot(t,y,'.','MarkerSize',markersize,'DisplayName',country);
plot(y_italy_plot,'.','MarkerSize',markersize,'DisplayName',sprintf('Italy %d days earlier',timeshift));

grid on
title(sprintf('Corona in %s',country))
xlabel('March')
ylabel('Positive Test Results')
legend('Location','NorthWest');