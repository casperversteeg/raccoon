#!/usr/bin/env python3

from paraview.simple import *
import os
from shutil import copy2

paraview.simple._DisableFirstRenderCameraReset()

cas_dir = "/media/cv/My Book/pmma/"

mu = ["0", "1e-12", "1e-11", "1e-10", "5e-9", "1e-9", "5e-8", "1e-8", "7.5e-7", "5e-7", "2.5e-7", "1e-7", "1e-6", "2.5e-6", "5e-6"]
bcs = [["0.09", "disp09e-5/"], ["0.10", "disp10e-5/"], ["0.11", "disp11e-5/"], ["0.12", "disp12e-5/"]]#, ["0.14", "disp14e-5/"], ["0.16", "disp16e-5/"]]
#bcs = [["0.11", "disp11e-5/"]]#, ["0.12", "disp12e-5/"], ["0.125", "disp12.5e-5/"], ["0.13", "disp13e-5/"]]
#bcs = [["0.12", "disp12e-5/"]]

# mu = ["0"]
#bcs= [["0.09", "disp09e-5/"]]

def generate_plots(root, mu, bc):
    file_name = "dynamic_pmma_mu_" + mu + "_" + bc + ".e"
    root_file_name = root + file_name
    if not os.path.exists(root_file_name):
        return
    # copy2(root_file_name, ".")
    if not os.path.exists(root_file_name):
        return
    print("Opening file: " + root_file_name)

    ex = ExodusIIReader(FileName = root_file_name)
    ex.ApplyDisplacements = 0

    # Get animation scene
    animationScene = GetAnimationScene()
    animationScene.UpdateAnimationUsingDataTimeSteps()
    animationScene.GoToLast()
    # Get active view
    renderView = GetActiveViewOrCreate('RenderView')

    exRefl = Reflect(Input=ex)
    exRefl.Plane = 'Y Min'
    exDisp = Show(exRefl, renderView)
    exDisp.Representation = 'Surface'
    exDisp.Position = [0.0, -4.0, 0.0]
    exDisp.Scale = [1.65, 1.65, 1.65]
    ColorBy(exDisp, ['Points','d'])

    dColor = GetColorTransferFunction('d')
    dColor.RescaleTransferFunction(0.0, 1.0)
    dColor.ApplyPreset('jet', True)
    dColBar = GetScalarBar(dColor, renderView)
    dColBar.Title = '$d$'
    dColBar.ComponentTitle = ''
    dColBar.AutomaticLabelFormat = 0
    dColBar.LabelFormat = '%-#6.1g'
    dColBar.LabelFontSize = 5
    dColBar.TitleFontSize = 9
    dColBar.WindowLocation = 'AnyLocation'
    dColBar.Position = [0.1, 0.8]
    dColBar.ScalarBarLength = 0.8
    dColBar.DrawTickMarks = 1
    dColBar.ScalarBarThickness = 9
    dataBounds = exRefl.GetDataInformation().GetBounds()
    dataCenter = (sum(dataBounds[0:2])/2, sum(dataBounds[2:4])/2, sum(dataBounds[4:6])/2)

    renderView.Update()
    renderView.ResetCamera(dataBounds)
    renderView.InteractionMode = '2D'
    renderView.CameraParallelProjection = 1
    renderView.CameraFocalPoint = dataCenter
    renderView.CameraPosition = (dataCenter[0], dataCenter[1], 1.0)
    renderView.CameraViewUp = (0, 1, 0)
    renderView.OrientationAxesVisibility = 0
    renderView.ResetCamera(dataBounds)

    SaveScreenshot(root + 'images/dynamic_pmma_mu_' + mu + "_" + bc + '.png', renderView, ImageResolution=[3840, 2160], TransparentBackground=0, CompressionLevel='0',OverrideColorPalette='WhiteBackground', FontScaling='Do not scale fonts')

    clip1 = Clip(Input=ex)
    clip1.ClipType = 'Scalar'
    clip1.Scalars = ['POINTS', 'd']
    clip1.Value = 0.45
    clip1.Invert = 0
    clip2 = Clip(Input=clip1)
    clip2.ClipType = 'Scalar'
    clip2.Scalars = ['POINTS', 'd']
    clip2.Value = 0.55

    clip3 = Clip(Input=ex)
    clip3.ClipType = 'Scalar'
    clip3.Scalars = ['POINTS', 'd']
    clip3.Value = 0.9
    clip3.Invert = 0

    line = PlotOverLine(Input=ex, Source="High Resolution Line Source")
    line.Source.Point1 = [-16, 0, 0]
    line.Source.Point2 = [16, 0, 0]
    time = PlotDataOverTime(Input=clip2)
    time.FieldAssociation = 'Cells'

    lView = CreateView('SpreadSheetView')
    lineDispl = Show(line, lView, 'SpreadSheetRepresentation')
    lView.HiddenColumnLabels = ['Process ID', 'Point ID', 'GlobalElementId', 'ObjectId', 'PedigreeElementId', 'Points_Magnitude', 'accel_', 'accel__Magnitude', 'arc_length', 'disp_', 'disp__Magnitude', 'hmax', 'hmin', 'stress_x', 'stress_x_Magnitude', 'stress_yy', 'vel_', 'vel__Magnitude', 'vtkValidPointMask']
    ExportView(root + 'images/dynamic_pmma_mu_' + mu + "_" + bc + '.csv', view=lView)

    dView = CreateView('SpreadSheetView')
    lineDispl2 = Show(clip3, dView, 'SpreadSheetRepresentation')
    dView.HiddenColumnLabels = ['Process ID', 'Block Number', 'Point ID', 'Points_Magnitude', 'accel_', 'accel__Magnitude', 'd', 'disp_', 'disp__Magnitude', 'vel_', 'vel__Magnitude']
    ExportView(root + 'images/dynamic_pmma_mu_' + mu + "_" + bc + '_slope.csv', view=dView)

    tView = CreateView('SpreadSheetView')
    timeDispl = Show(time, tView, 'SpreadSheetRepresentation')
    # Properties modified on spreadSheetView2
    tView.HiddenColumnLabels = ['Process ID', 'Block Number', 'Row ID', 'N', 'avg(ObjectId)', 'avg(PedigreeElementId)', 'avg(crack_inertia)', 'avg(crack_speed)', 'avg(d_vel)', 'avg(dissipation_modulus)', 'avg(energy_release_rate)', 'avg(gamma)', 'avg(gamma_dot)', 'avg(hmax)', 'avg(hmin)', 'avg(mobility)', 'avg(stress_x (0))', 'avg(stress_x (1))', 'avg(stress_x (2))', 'avg(stress_x (Magnitude))', 'avg(stress_yy)', 'max(ObjectId)', 'max(PedigreeElementId)', 'max(crack_inertia)', 'max(d_vel)', 'max(dissipation_modulus)', 'max(energy_release_rate)', 'max(gamma)', 'max(gamma_dot)', 'max(hmax)', 'max(hmin)', 'max(mobility)', 'max(stress_x (2))', 'max(stress_x (Magnitude))', 'med(ObjectId)', 'med(PedigreeElementId)', 'med(crack_inertia)', 'med(crack_speed)', 'med(d_vel)', 'med(dissipation_modulus)', 'med(energy_release_rate)', 'med(gamma)', 'med(gamma_dot)', 'med(hmax)', 'med(hmin)', 'med(mobility)', 'med(stress_x (0))', 'med(stress_x (1))', 'med(stress_x (2))', 'med(stress_x (Magnitude))', 'med(stress_yy)', 'min(ObjectId)', 'min(PedigreeElementId)', 'min(crack_inertia)', 'min(crack_speed)', 'min(d_vel)', 'min(dissipation_modulus)', 'min(energy_release_rate)', 'min(gamma)', 'min(gamma_dot)', 'min(hmax)', 'min(hmin)', 'min(mobility)', 'min(stress_x (0))', 'min(stress_x (1))', 'min(stress_x (2))', 'min(stress_x (Magnitude))', 'min(stress_yy)', 'q1(ObjectId)', 'q1(PedigreeElementId)', 'q1(crack_inertia)', 'q1(crack_speed)', 'q1(d_vel)', 'q1(dissipation_modulus)', 'q1(energy_release_rate)', 'q1(gamma)', 'q1(gamma_dot)', 'q1(hmax)', 'q1(hmin)', 'q1(mobility)', 'q1(stress_x (0))', 'q1(stress_x (1))', 'q1(stress_x (2))', 'q1(stress_x (Magnitude))', 'q1(stress_yy)', 'q3(ObjectId)', 'q3(PedigreeElementId)', 'q3(crack_inertia)', 'q3(crack_speed)', 'q3(d_vel)', 'q3(dissipation_modulus)', 'q3(energy_release_rate)', 'q3(gamma)', 'q3(gamma_dot)', 'q3(hmax)', 'q3(hmin)', 'q3(mobility)', 'q3(stress_x (0))', 'q3(stress_x (1))', 'q3(stress_x (2))', 'q3(stress_x (Magnitude))', 'q3(stress_yy)', 'std(ObjectId)', 'std(PedigreeElementId)', 'std(crack_inertia)', 'std(crack_speed)', 'std(d_vel)', 'std(dissipation_modulus)', 'std(energy_release_rate)', 'std(gamma)', 'std(gamma_dot)', 'std(hmax)', 'std(hmin)', 'std(mobility)', 'std(stress_x (0))', 'std(stress_x (1))', 'std(stress_x (2))', 'std(stress_x (Magnitude))', 'std(stress_yy)', 'vtkValidPointMask']
    ExportView(root + 'images/dynamic_pmma_mu_' + mu + "_" + bc + '_d_vel.csv', view=tView)

    Disconnect()
    Connect()
    # Delete(time)
    # Delete(line)
    # Delete(clip3)
    # Delete(clip2)
    # Delete(clip1)
    # Delete(exRefl)
    # Delete(ex)
    # os.remove(file_name)
    return


for m in mu:
    for bc in bcs:
        generate_plots(cas_dir + bc[1], m, bc[0])
