import bpy
import bmesh
import os


#function for changing the topology of the object by triangulating it
def triangulate_object(obj):
    me = obj.data
    # Get a BMesh representation
    bm = bmesh.new()
    bm.from_mesh(me)

    bmesh.ops.triangulate(bm, faces=bm.faces[:], quad_method=0, ngon_method=0)

    # Finish up, write the bmesh back to the mesh
    bm.to_mesh(me)
    bm.free()


#retrieves the radi for the Envelope based elip
def min_max_axis(object):
     Xs = []
     Ys = []
     Zs = []
     boundaries = []

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

     E_radi.append((abs(boundaries[0] - boundaries[1]))/2)
     E_radi.append((abs(boundaries[2] - boundaries[3]))/2)
     E_radi.append((abs(boundaries[4] - boundaries[5]))/2)



#create folder and move blend file into it
file = bpy.path.basename(bpy.context.blend_data.filepath)

filename = file.strip('.blend')

mom_folder = '/Users/rileysterman/Desktop/blender objects/pre-pre-animation/'

object_folder = mom_folder + filename

os.makedirs(object_folder)

os.rename(bpy.context.blend_data.filepath, object_folder + '/' + file)


#identify object of interest,create lists of elip radi, and reset its location to the origin, and set the center to be based on mass volume 
ob = bpy.data.objects[0]
E_radi = []

ob.location = (0,0,0)
#ob.origin_set(type='ORIGIN_CENTER_OF_VOLUME')


#triangulate the object
triangulate_object(ob)

#export stl file of triangulated object into the object folder
stl_path = object_folder + '/' + filename + '.stl'
bpy.ops.export_mesh.stl(filepath=stl_path)

#export fbx file
fbx_path = object_folder + '/' + filename + '.fbx'
bpy.ops.export_scene.fbx(filepath =fbx_path)

# E_radi
min_max_axis(ob)

#noramlize E_radi
radi_sum = E_radi[0] + E_radi[1] + E_radi[2]
E_radi[0] = E_radi[0] /radi_sum
E_radi[1] = E_radi[1] /radi_sum
E_radi[2] = E_radi[2] /radi_sum

E = open(object_folder +'/'+ 'E' + filename, 'w+')
E.write(str(E_radi[0]) + '~' + str(E_radi[1]) + '~' + str(E_radi[2]))
E.close()


