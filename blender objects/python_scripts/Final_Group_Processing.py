import os
import bpy
import bmesh
import time



def max_axis(object):
     Xs = []
     Ys = []
     Zs = []
     boundaries = []
     radi = []

     coords = [(object.matrix_world * v.co) for v in object.data.vertices]

     for vert in coords:
         Xs.append(vert[0])
         Ys.append(vert[1])
         Zs.append(vert[2])

     Xs.sort()
     Ys.sort()
     Zs.sort()


     boundaries.append(Xs[len(Xs) - 1])
     boundaries.append(Xs[0])
     boundaries.append(Ys[len(Ys) - 1])
     boundaries.append(Ys[0])
     boundaries.append(Zs[len(Zs) - 1])
     boundaries.append(Zs[0])

     radi.append((abs(boundaries[0] - boundaries[1]))/2)
     radi.append((abs(boundaries[2] - boundaries[3]))/2)
     radi.append((abs(boundaries[4] - boundaries[5]))/2)

     return max(radi[0], radi[1], radi[2])




Dir = "/Users/rileysterman/Desktop/blender objects/pre-animation"

folders = os.listdir(Dir)



for i in range(0,len(folders) - 1):
    if folders[i] == '.DS_Store':
        del folders[i]

folders.sort()

#collect done file names
'''
DoneDir = "/Users/rileysterman/Desktop/blender objects/objectsFinal"

complete = os.listdir(DoneDir)

completeNames = []

for w in range(0,len(complete) - 1):
    if complete[w] == '.DS_Store':
        del complete[w]

for k in range (0,len(complete)):
    name = open(DoneDir+"/"+complete[k]+"/"+"name"+complete[k]+".txt" ,'r')
    completeNames.append(name.read())
    name.close()

#remove complete names from folders
corrupt = []
for l in range(0,len(folders) - 1):
    if folders[l] not in completeNames:
        corrupt.append(folders[l])

list = open("/Users/rileysterman/Desktop/blender objects/corrupt.txt", 'w')
list.write(str(len(corrupt)))
for u in range(0, len(corrupt)):
    list.write('\n' + str(corrupt[u]))

list.close
'''


#make new file
#create sphere
#aplly E changes
#measure major axis
#export to new file
#import fbx
#measure major axis
#compute ratio between ellip and object
#resize
#export to new file
#create sphere
#apply M changes
#export to new file
count = 1
corrupt = []

for folder in folders:

     try:
         path = "/Users/rileysterman/Desktop/blender objects/objectsFinal/"
         os.mkdir(path+str(count))
         NameFile = open(path +str(count)+'/'+"name" +str(count)+".txt", 'w+')
         time.sleep(1)
         NameFile.write(folder)
         NameFile.close()


         Efile = open(Dir+'/'+folder+"/E"+folder+".txt", 'r')
         Mfile = open(Dir+'/'+folder+"/M"+folder+".txt",'r')
         Edata = Efile.read()
         Mdata = Mfile.read()
         Eeigen = Edata.split("~")
         Meigen = Mdata.split("~")
         Efile.close()
         Mfile.close()

         #Estuff
         bpy.ops.mesh.primitive_uv_sphere_add()
         bpy.data.objects[0].select = True
         bpy.ops.transform.resize(value=(float(Eeigen[0]),float(Eeigen[1]),float(Eeigen[2])))
         Elength = max_axis(bpy.data.objects[0])
         bpy.ops.export_scene.obj(filepath = path +str(count)+'/'+'E'+str(count)+'.obj', use_uvs = True)
         bpy.ops.object.delete(use_global=False)

         #Mstuff
         bpy.ops.mesh.primitive_uv_sphere_add()
         bpy.data.objects[0].select = True
         bpy.ops.transform.resize(value=(float(Meigen[0]),float(Meigen[1]),float(Meigen[2])))
         Mlength = max_axis(bpy.data.objects[0])
         ratio = Elength/Mlength
         bpy.ops.transform.resize(value=(ratio,ratio,ratio))
         bpy.ops.export_scene.obj(filepath = path +str(count)+'/'+'M'+str(count) +'.obj',use_uvs = True)
         bpy.ops.object.delete(use_global=False)

         #Ostuff
         bpy.ops.import_scene.fbx( filepath =Dir + '/'+folder +'/'+folder +'.fbx')
         Olength = max_axis(bpy.data.objects[0])
         ratio2 = Elength/Olength
         bpy.data.objects[0].select = True
         bpy.ops.transform.resize(value=(ratio,ratio,ratio))
         bpy.ops.export_scene.obj(filepath = path +str(count)+'/'+'O'+str(count)+'.obj',use_uvs = True)
         bpy.ops.object.delete(use_global=False)



         count = count + 1
     except:
         print("error")
         corrupt.append(folder)

    list = open("/Users/rileysterman/Desktop/blender objects/corrupt.txt", 'w')
    list.write(str(len(corrupt)))
    for u in range(0, len(corrupt)):
        list.write('\n' + str(corrupt[u]))
    list.close()





     #nameing scheme
     #folder will be <index> object will be O<index> then E<index> and M<index>
     #sending objects to unreal_ready
