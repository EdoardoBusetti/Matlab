#Used to reformat the data in a matlab compatible way
Handle = open("average-height-of-women.csv","r")
StringFromCSV = Handle.read()
FormattedCSV = StringFromCSV.replace(' ','_').replace(',,',',NA,')
print(FormattedCSV)