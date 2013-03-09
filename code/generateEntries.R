stations <- read.csv('../Remote-Booth-Station.csv')

allFileNames <- list.files(path='../', recursive=TRUE)
allFileNames <- grep("turnstile2", allFileNames, value=TRUE)

for (i in 1:length(allFileNames)) {
  fileName <- allFileNames[i]
  print(fileName)

temp <- read.csv(paste('../', fileName, sep=''), as.is=T)
names(temp) <- c("control_area", "unit", "scp", "date", "time", "desc", "entry_count", "exit_count")
temp$uid <- paste(temp$control_area, temp$unit, temp$scp, sep="|")
temp$date_time <- paste(temp$date, temp$time)
temp$datetime <- strptime(temp$date_time, format="%m-%d-%y %H:%M:%S")

temp$date <- NULL
temp$time <- NULL
temp$exit_count <- NULL
temp$date_time <- NULL

temp <- temp[order(temp$uid, temp$datetime),]

temp$uid_next <- c(temp$uid[-1], "none")
temp$datetime_next <- c(temp$datetime[-1], strptime("2020-01-01 00:00:00", "%Y-%m-%d %H:%M:%S"))
temp$entry_count_next <- c(temp$entry_count[-1], 999999999)

temp$datetime_diff <- temp$datetime_next - temp$datetime

temp$entry_count_diff <- temp$entry_count_next - temp$entry_count

t <- subset(temp, entry_count_diff > 0 & uid == uid_next & 
                  datetime_diff <= strptime("2020-01-01 04:00:00", "%Y-%m-%d %H:%M:%S") -
                                   strptime("2020-01-01 00:00:00", "%Y-%m-%d %H:%M:%S") &
                  entry_count_diff < 8000) # rough sanity checks...

t$day <- substr(t$datetime, 1, 10)

t$desc <- NULL
t$entry_count <- NULL
t$uid <- NULL
t$datetime <- NULL
t$uid_next <- NULL
t$datetime_next <- NULL
t$datetime_diff <- NULL
t$entry_count_next <- NULL
t <- t[,c("control_area", "unit", "scp", "day", "entry_count_diff")]
names(t) <- c("control_area", "unit", "scp", "day", "entries")

u <- merge(t, stations, by.x=c("unit", "control_area"), by.y=c("Remote", "Booth"))

results <- aggregate(entries ~ Station + day, data=u, FUN="sum")

  write.csv(results, paste('../turnstile3/',i,'.csv',sep=''), row.names=FALSE)

}
