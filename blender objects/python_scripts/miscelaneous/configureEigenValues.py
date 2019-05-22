#iterate through objects
#check if eigen files have .txt extension
#add if

import os

Dir = "/Users/rileysterman/Desktop/blender objects/pre-animation"
folders = os.listdir(Dir)

for i in range(0,len(folders) - 1):
    if folders[i] == '.DS_Store':
        del folders[i]

#create array of files in folder
#if file starts will M or E rename with M or E and folder name and .txt
for folder in folders:
    files = os.listdir(Dir +"/"+ folder)
    for file in files:
        FILE = list(file)
        if FILE[0] == 'M':
            os.rename(Dir +'/' + folder + "/" +file,Dir+'/'+folder+"/"+"M"+folder+".txt")
        if FILE[0] == 'E':
            os.rename(Dir +'/' + folder + "/" +file,Dir+'/'+folder+"/"+"E"+folder+".txt")
        if FILE[len(FILE) - 1] == 'x' and FILE[len(FILE) - 2] == 'b':
            os.rename(Dir +'/' + folder + "/" +file,Dir+'/'+folder+"/"+folder+".fbx")
