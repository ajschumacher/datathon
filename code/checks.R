
test <- read.csv('../turnstile2/turnstile_120428.txt', header=FALSE)
test2 <- read.csv('../turnstile2/turnstile_110402.txt', header=FALSE)

raw <- read.csv('../results.csv')
sorted <- raw[order(raw$Station, raw$day),]
write.csv(sorted, '../resultsSorted.csv',row.names=FALSE)