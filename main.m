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

%% Get the zones

country = 'Netherlands'; % country for which we want to fit
zones = getzones('Netherlands'); % what zones are there?

%% Get the data

zone = 'Netherlands';

y = getinfections(country, zone);
offset = 40; % start plots from march 1
y = y(offset:end); % only march
t = 1:length(y); % time in days from March

%% Make figure with data from NL

figure;
plot(t,y,'.','MarkerSize',markersize,'DisplayName',country);
hold on;

grid on
title(sprintf('Corona in %s',country))
xlabel('March')
legend('Location','NorthWest');

%% Compute exponential fit using least squares

skip = 5; % do not fit first 5 days
mylim = 20; % until when to predict

t = t(skip:end);
y = y(skip:end);

X = [t',ones(size(t'))];
Y = log10(y');

beta = inv(X'*X)*X'*Y;

tfar = [(1:mylim)',ones(mylim,1)];
ypred = tfar*beta;
ypred2 = 10.^ypred;

plot(1:mylim,ypred2,':','DisplayName',sprintf('%s Fit',country),'LineWidth',linewidth);
legend('Location','NorthWest');

%% Compute growth factors

the_exponent = 10.^beta(1);
the_factor = 10.^beta(2);
the_function = the_exponent.^tfar(:,1) * 10.^beta(2);

double_time = 1/beta(1);
fprintf('every %.1f days the amount of infections grows by a factor 10\n',log(10)/log(the_exponent))
fprintf('every %.1f days the amount of infections grows by a factor 2\n',log(2)/log(the_exponent))

%% Compare with Italy

y_italy = getinfections('Italy','');

offset = 40; % this is march 1
timeshift = 12; % delay time series by 12 days
until_date = 40-timeshift+max(t); % plot until current date

y_italy_plot = y_italy((offset-timeshift):until_date);

plot(y_italy_plot,'.','MarkerSize',markersize,'DisplayName',sprintf('Italy %d days earlier',timeshift));

legend('Location','NorthWest');