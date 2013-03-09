import os
import csv

sourceDirName = '../turnstile/'
destDirName = '../turnstile2/'
fileNames = os.listdir(sourceDirName)

for fileName in fileNames:
	print sourceDirName + fileName
	f = file(sourceDirName + fileName, 'rb')
	reader = csv.reader(x.replace('\0', '') for x in f)
	o = file(destDirName + fileName, 'wb')
	writer = csv.writer(o)
	for line in reader:
		line = [str.strip(s) for s in line]
		# 3 and 4 should be 8-character date and time (each)
		# hopefully this will exclude totally weird rows
		if ((len(line)-3) % 5 != 0) or len(line[3]) != 8 or len(line[4]) != 8:
			print line  # represents error
		else:
			numEntries = (len(line)-3) / 5
			for i in range(numEntries):
				writer.writerow(line[0:3] + line[3+5*i:8+5*i])
	f.close()
	o.close()
