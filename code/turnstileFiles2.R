allFileNames <- list.files(path='../', recursive=TRUE)
allFileNames <- grep("turnstile2", allFileNames, value=TRUE)

# clumsy hack...
rows <- c()
cols <- c()
nas <- c()

for (fileName in allFileNames) {
  temp <- read.csv(paste('../', fileName, sep=''), header=FALSE)
  rows <- c(rows, nrow(temp))
  cols <- c(cols, ncol(temp))
  nas <- c(nas, sum(is.na(temp)))
}

results <- data.frame(filename=allFileNames,
                      nrows=rows,
                      ncols=cols,
                      nas=nas)

write.csv(results, 'turnstileFiles2.csv', row.names=FALSE)


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
