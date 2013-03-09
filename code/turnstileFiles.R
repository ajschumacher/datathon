allFileNames <- list.files(path='../', recursive=TRUE, pattern='turnstile.*txt')

# clumsy hack...
rows <- c()
cols <- c()
numericCols <- c()
maxNumeric <- c()
nas <- c()

for (fileName in allFileNames) {
  temp <- read.csv(paste('../', fileName, sep=''), header=FALSE)
  rows <- c(rows, nrow(temp))
  cols <- c(cols, ncol(temp))
  numericCols <- c(numericCols, sum(sapply(temp,class) == 'numeric'))
  maxNumeric <- c(maxNumeric, max(temp[,sapply(temp,class) == 'numeric'], na.rm=TRUE))
  nas <- c(nas, sum(is.na(temp)))
}

results <- data.frame(filename=allFileNames,
                      nrows=rows,
                      ncols=cols,
                      numericCols=numericCols,
                      maxNumeric=maxNumeric,
                      nas=nas)

write.csv(results, 'turnstileFiles.csv', row.names=FALSE)

# hmmm
with(results, hist(nrows))

# good!
with(results, table(ncols))

# issues!
with(results, table(numericCols))

# hmmm
with(results, hist(nas))
with(results, plot(nrows, nas, pch=19, cex=0.4))

# also weird!
with(results, table(maxNumeric))
