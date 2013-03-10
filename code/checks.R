
test <- read.csv('../turnstile2/turnstile_120428.txt', header=FALSE)
test2 <- read.csv('../turnstile2/turnstile_110402.txt', header=FALSE)

raw <- read.csv('../results.csv')
sorted <- raw[order(raw$Station, raw$day),]
write.csv(sorted, '../resultsSorted.csv',row.names=FALSE)

sorted$date <- as.Date(sorted$day)

daily <- aggregate(entries ~ day, data=raw, FUN="sum")
daily$date <- as.Date(daily$day)

daily$day <- NULL

write.csv(daily, '../resultsDaily.csv', row.names=FALSE)

with(daily, plot(date, entries))

with(subset(sorted, Station=="BEDFORD AVE"), plot(date, entries))
with(subset(sorted, Station=="42 ST-TIMES SQ"), plot(date, entries))
with(subset(sorted, Station=="111 ST"), plot(date, entries))
with(subset(sorted, Station=="DITMARS BL-31 S"), plot(date, entries))
with(subset(sorted, Station=="28 ST"), plot(date, entries))
with(subset(sorted, Station=="CARROLL ST"), plot(date, entries, pch=19, cex=0.4, col="blue"))


# heavy snow days
snow <- c('20101226', '20101227', '20110111', '20110112', '20110121',
 '20110126', '20110127', '20110221', '20120121', '20121107',
 '20130208', '20130209')

# heavy wind days
wind <- c(20100725.0,
20100827.0,
20100913.0,
20101024.0,
20110519.0,
20110520.0,
20110530.0,
20110531.0,
20110616.0,
20110617.0,
20110828.0,
20111022.0,
20111023.0,
20111214.0,
20120129.0,
20120130.0,
20120414.0,
20120524.0,
20120527.0,
20120702.0,
20120917.0,
20121029.0,
20121030.0,
20121031.0,
20121101.0,
20121102.0,
20130129.0)
wind <- as.character(wind)

# heavy precipitation days
precip <- c('20100503', '20100822', '20100927', '20101001', '20101011',
 '20101201', '20101212', '20110118', '20110126', '20110225',
 '20110306', '20110416', '20110518', '20110617', '20110809',
 '20110814', '20110819', '20110827', '20110828', '20110906',
 '20110907', '20110923', '20111019', '20111029', '20111122',
 '20111207', '20120112', '20120422', '20120521', '20120718',
 '20120918', '20120928', '20121107', '20130208', '20130227')

# heat waves
we've got two heat waves:
heat <- c('20100829','20100830','20100831','20100901','20100902',
'20120704','20120705','20120706','20120707','20120708')

weather <- c(snow, wind, precip, heat)
weather <- unique(weather)
weatherDays <- as.Date(weather, format="%Y%m%d")

sorted$weather <- sorted$date %in% weatherDays
stationWeather <- as.data.frame(t(with(sorted, tapply(entries, list(weather, Station), FUN="mean"))))
stationWeather$diff <- stationWeather[['FALSE']] - stationWeather[['TRUE']]
stationWeather$normedDiff <- stationWeather$diff / stationWeather[['FALSE']]
stationWeather <- stationWeather[order(stationWeather$normedDiff),]

write.csv(stationWeather, 'stationWeatherDiff.csv')