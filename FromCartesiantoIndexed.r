rm(list=ls())
Sys.setenv(TZ='GMT')
Sys.setlocale("LC_TIME", "English")
par(mfrow=c(1,1))
library(ggplot2)
library(tidyr)

Pollutant<- read.csv('C:/.csv', sep=';') #It opens your file, in the example a .csv



#confert cartesian to indexed, use pivot_longer from tidyr
#I had one column with dates and then 24 columns with each hour of the day:
#date Pollutant_value hour1 hour2 hour3 .... hour24
#01-01-2020 CO   0.5 0.6   0.4 ...  0.2
#01-01-2020 NO2 7    6     7   ...    2

#with this step i solved to indexed values for date and hour like this:
#date        hour Pollutant_value  pollutant
#01-01-2020  hour1      0.5          CO
#01-01-2020  hour2      0.6          CO
#01-01-2020  hour3      0.4          CO
#....
#01-01-2020  24      3          NO2

tpol<- pivot_longer(Pollutant, cols=13:36, names_to = "hur", values_to = "POLUTANT_VALUE") #


#Then I wanted to have one column per pollutant, I transposed using rephase2 


require(reshape2)
df_transpose<-dcast(tpol, CODI_EOI + dateA + hour + MUNICIPI+ NOM_ESTACIO + LATITUD + LONGITUD + ALTITUD ~ POLLUTANT, value.var="Pollutant_value")

# some fixing data to my df were

#cleaning hour colum to make it numerical:

df_transpose$hour <- stringr::str_replace(df_transpose$hour, 'hour', '')


#merge hour and data to form POSIXct

df_transpose$date<-paste(df_transpose$date,' ', df_transpose$hour, ':00:00',sep='')

#convert to POSIXct

df_transpose$date<-as.POSIXct(df_transpose$date, tz='GMT')


##save values:

write.csv()

