# Exponential Fit for Corona Cases 

![example of fit for the Netherlands](https://github.com/tomviering/coronaNL/raw/master/fit.png)

Output:
```
y = C A^t
where t is the day in March
A = 1.26338
C = 34.3281
every 9.8 days the amount of infections grows by a factor 10
every 3.0 days the amount of infections grows by a factor 2
```

Downloads the latest Corona data from Johns Hopkins University and performs an exponential fit for any country.
It also makes a comparison with Italy. 

Simply run main.m to get the figure.

Thanks to Johns Hopkins University! You can find their data here:
https://github.com/CSSEGISandData/COVID-19

