#Version de python usada 3.8.0
#Instrucciones, tan solo hay que llamar al programa desde consola usando py autoParser.py. Para ello, primero hay que copiar el autoparser a la carpeta en cuestion
#Como resultado, se generaran tantos ficheros con extension psd como ficheros se hayan parseado

rate=200 #1050 muestras por segundo

import os
relevant_path = "."
included_extensions = ['csv']
file_names = [fn for fn in os.listdir(relevant_path)
              if any(fn.endswith(ext) for ext in included_extensions)]
			  
print(file_names)

for origFileName in file_names:
	#origFileName = "600_VVIDEO1.csv"
	parsedFileName = origFileName+".psd"
	print("---------------------------------------")
	print("Processing the file"+origFileName+"....")
	print("---------------------------------------")
	f = open(origFileName)# read
	g = open(parsedFileName,"w")
	g.write("original final;"+origFileName+"\n")
	g.write("timestamp;packet_id;SKT;BVP;GSR;EMG;Resp\n")
	timestampPrev = -1
	ifError = 0
	primera_vez = 0
	for linea in f:
		# print(linea)
		step0 = linea.split(";") #split into timestamp (in the first part) and the rest 
		timestamp = step0[0]
		
		if timestampPrev == -1:
			timestampPrev = timestamp
			numSamples = 0
		else:
			if timestampPrev != timestamp:
				if primera_vez == 0:
					primera_vez = 1 #to avoid a warning the first time period analized, which is usual
				else:
					print("Info: From",timestampPrev,"to",timestamp,": ",str(numSamples),"samples")
				numSamples = 0
				timestampPrev = timestamp
			
		step1 = step0[1].split("[") #split into MAC info and the measurements (in the second part)
		
		for group in step1[2:len(step1)]:
			split2 = group.split("]") #remove the last "]" character in the group
			split3 = split2[0].split(",")
			
			if len(split3)!= 7: #10 is the number of sensors
				print("error for the number of measurements in group: ")
				print(len(split3))
				print(group)
			else:
				g.write(timestamp+";"+split3[0]+";"+split3[2]+";"+split3[3]+";"+split3[4]+";"+split3[5]+";"+split3[6]+";"+"\n")
				numSamples = numSamples+1
			
			
		#error control
		if len(step0)!= 2: #div. between timestampt and measurements
			print("Error between timestampt and measurements: " + str(len(step0)))
			ifError = 1
		
		if len(step1)!= 32: #the groups of measurements for a line 
			print("Warning for the groups in measurements in a line: " + str(len(step1)))
			ifError = 1
		
	if ifError == 1:
		print("Result: error!!!")
	else:
		print("Result: success, file " + parsedFileName + " generated!!")
		
	f.close()
	g.close()