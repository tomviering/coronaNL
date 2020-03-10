function ypred2 = makegraph(y)

the_markersize = 20;
the_linewidth = 5;

%y(9) = 321; % 09-03
%y(8) = 265; % 08-03
%y(7) = 188; % 07-03
%y(6) = nan(1,1);
%y(5) = nan(1,1); 
%y(4) = 38;  % 04-03
%y(3) = 24;  % 03-03
%y(2) = 18;  % 02-03
%y(1) = 10;  % 01-03

t = 1:length(y);

fh = figure;
set(fh,'DefaultLineLineWidth',the_linewidth)
semilogy(t,y,'k.','MarkerSize',the_markersize)
%xlabel('march')
%ylabel('corona gevallen in NL')

y2 = y;
y2(isnan(y2)) = [];
t2 = t;
t2(isnan(y)) = [];

X = [t2',ones(size(t2'))];
Y = log10(y2');

beta = inv(X'*X)*X'*Y;

mylim = 20;
tfar = [(1:mylim)',ones(mylim,1)];
ypred = tfar*beta;
ypred2 = 10.^ypred;

hold on;
l_pred = semilogy(1:mylim,ypred2,':');

l_dots = semilogy(t,y,'.','MarkerSize',the_markersize);

numbers = get(gca,'XTick');

max_x = max(numbers);
setnumbers = 1:5:max_x;
%setnumbers = [1,4,7,9,13,16];
setnumbers = 1:2:19;

dates = datetime(2020,3,setnumbers);

mylabels = datestr(dates,'dd mmmm');

set(gca,'XTick',setnumbers)

xlabels_dates = cell(size(mylabels,1));
for i = 1:length(xlabels_dates)
    %xlabels_dates{i} = mylabels(i,:);
    xlabels_dates{i} = sprintf('%d',setnumbers(i));
end

%xlabel('Maart')

set(gca,'XTickLabel',xlabels_dates)

my_y_labels = [10, 100, 1000, 10000];
set(gca,'YTick',my_y_labels)

ylabels = cell(length(my_y_labels),1);
for i = 1:length(my_y_labels)
    ylabels{i} = addComma(my_y_labels(i));
end

set(gca,'YTickLabel',ylabels)

inh_italy = 60; % inhabitents in italy in millions
ing_netherland = 17; % ..

cases_italy = 9000; % #cases when quarantine started
cases_netherland = cases_italy/(inh_italy/ing_netherland);

%threshold = find(ypred2 > cases_netherland);
%the_threshold = threshold(1)-1;
%y_quarantine = ypred2(the_threshold);

%semilogy(tfar,repmat(y_quarantine,1,length(tfar)),':k','Color',[0.9290, 0.6940, 0.1250])
%text(tfar(1),y_quarantine+1000,'Quarantine in Italie')
%semilogy([tfar(the_threshold),tfar(the_threshold)],[y_quarantine,10],':k','Color',[0.9290, 0.6940, 0.1250])

the_exponent = 10.^beta(1);
the_factor = 10.^beta(2);
the_function = the_exponent.^tfar(:,1) * 10.^beta(2);

the_factor
the_exponent

double_time = 1/beta(1);
fprintf('every %.1f days the amount of infections grows by a factor 10\n',log(10)/log(the_exponent))
fprintf('every %.1f days the amount of infections grows by a factor 2\n',log(2)/log(the_exponent))

grid on

legend([l_dots,l_pred],'Aantal gevallen',sprintf('Trendlijn %.1f\\cdot%.1f^t',the_factor,the_exponent),'Location','SouthEast')

%title('Corona in Nederland (Voorspelling)')

%semilogy(tfar(:,1),the_function,'g')

%set(gca,'XMinorGrid','on')
%grid minor

%export_fig('corona_NL','-pdf','-transparent')