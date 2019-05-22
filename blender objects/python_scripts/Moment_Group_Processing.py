import trimesh
import os

folders = os.listdir('/Users/rileysterman/Desktop/blender objects/pre-pre-animation')

for i in range(0,len(folders) - 1):
    if folders[i] == '.DS_Store':
        del folders[i]

for fold in folders:

    path = '/Users/rileysterman/Desktop/blender objects/pre-pre-animation/' + fold + '/' + fold + '.stl'
    print(fold)
    print(path)

    mesh = trimesh.load('/Users/rileysterman/Desktop/blender objects/pre-pre-animation/' + fold + '/' + fold + '.stl')

    mesh.vertices -= mesh.center_mass

    moments = [mesh.moment_inertia[0][0], mesh.moment_inertia[1][1], mesh.moment_inertia[2][2]]

    mom_sum = moments[0] + moments[1] + moments[2]
    for i in range(0, 3):
        moments[i] = moments[i] / mom_sum

    m_radi = open('/Users/rileysterman/Desktop/blender objects/pre-pre-animation/' + fold + '/' + 'M' + fold, 'w+')
    m_radi.write(str(moments[0]) + '~' + str(moments[1]) + '~' + str(moments[2]))
    m_radi.close()

    os.rename('/Users/rileysterman/Desktop/blender objects/pre-pre-animation/' + fold,
              '/Users/rileysterman/Desktop/blender objects/pre-animation/' + fold)
