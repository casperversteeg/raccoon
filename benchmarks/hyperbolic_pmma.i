E = 3.09e3
rho = 1180e-12
nu = 0.35

# ACTUAL sigmac = 75, Gc = 0.3

# sigmac = 60
psic = 0.405
Gc = 1
l = 0.3

alpha = -0.3
beta = 0.4225
gamma = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  file = 'output/dynamic_pmma_static.e'
[]

[Adaptivity]
  marker = box
  initial_steps = 1
  stop_time = 1e-10
  max_h_level = 1
  [Markers]
    [box]
      type = BoxMarker
      bottom_left = '-14 -0.01 0'
      top_right = '0 1.51 0'
      inside = refine
      outside = do_nothing
    []
  []
[]

[UserObjects]
  [E_el_active]
    type = ADFPIMaterialPropertyUserObject
    mat_prop = 'E_el_active'
  []
[]

[Variables]
  [disp_x]
    initial_from_file_var = 'disp_x'
  []
  [disp_y]
    initial_from_file_var = 'disp_y'
  []
  [d]
  []
[]

[AuxVariables]
  [stress_11]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_12]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_22]
    order = CONSTANT
    family = MONOMIAL
  []
  [hmin]
    order = CONSTANT
    family = MONOMIAL
  []
  [hmax]
    order = CONSTANT
    family = MONOMIAL
  []
  [bounds_dummy]
  []
  [vel_x]
  []
  [vel_y]
  []
  [d_vel]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Bounds]
  [irreversibility]
    type = VariableOldValueBoundsAux
    variable = 'bounds_dummy'
    bounded_variable = 'd'
    bound_type = lower
  []
  [upper]
    type = ConstantBoundsAux
    variable = 'bounds_dummy'
    bounded_variable = 'd'
    bound_value = 1
    bound_type = upper
  []
[]

[Kernels]
  [solid_x]
    type = ADDynamicStressDivergenceTensors
    variable = disp_x
    static_initialization = true
    component = 0
    alpha = '${alpha}'
    use_displaced_mesh = false
  []
  [solid_y]
    type = ADDynamicStressDivergenceTensors
    variable = disp_y
    static_initialization = true
    component = 1
    alpha = '${alpha}'
    use_displaced_mesh = false
  []

  [inertia_x]
    type = ADInertialForce
    variable = disp_x
    alpha = '${alpha}'
    use_displaced_mesh = false
  []
  [inertia_y]
    type = ADInertialForce
    variable = disp_y
    alpha = '${alpha}'
    use_displaced_mesh = false
  []

  # [pff_inertia]
  #   type = ADDynamicPFFInertia
  #   use_displaced_mesh = false
  #   variable = 'd'
  #   alpha = '${alpha}'
  # []
  # [pff_grad]
  #   type = ADDynamicPFFGradientTimeDerivative
  #   variable = 'd'
  # []
  [pff_diff]
    type = ADPFFDiffusion
    variable = 'd'
  []
  [pff_barr]
    type = ADPFFBarrier
    variable = 'd'
  []
  [pff_react]
    type = ADPFFReaction
    variable = 'd'
    driving_energy_uo = 'E_el_active'
  []
[]

[AuxKernels]
  [stressxx]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_11
    index_i = 0
    index_j = 0
    execute_on = TIMESTEP_END
  []
  [stressxy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_12
    index_i = 0
    index_j = 1
    execute_on = TIMESTEP_END
  []
  [stressyy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_22
    index_i = 1
    index_j = 1
    execute_on = TIMESTEP_END
  []
  [min_h]
    type = ElementLengthAux
    variable = 'hmin'
    method = min
    execute_on = 'INITIAL'
  []
  [max_h]
    type = ElementLengthAux
    variable = 'hmax'
    method = max
    execute_on = 'INITIAL'
  []
  [vx]
    type = TestNewmarkTI
    variable = 'vel_x'
    displacement = 'disp_x'
    execute_on = 'TIMESTEP_END'
  []
  [vy]
    type = TestNewmarkTI
    variable = 'vel_y'
    displacement = 'disp_y'
    execute_on = 'TIMESTEP_END'
  []
  [d_vel]
    type = ADMaterialRealAux
    variable = 'd_vel'
    property = 'crack_speed'
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'density phase_field_regularization_length critical_fracture_energy'
    prop_values = '${rho} ${l} ${psic}'
  []
  [elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = '${E}'
    poissons_ratio = '${nu}'
  []
  [stress]
    type = SmallStrainDegradedElasticPK2Stress_NoSplit
    d = 'd'
  []
  [strain]
    type = ADComputeSmallStrain
  []
  [Gc]
    type = ADConstantEnergyReleaseRate
    d = 'd'
    static_fracture_energy = '${Gc}'
    limiting_crack_speed = 1e10
  []
  [local_dissipation]
    type = LinearLocalDissipation
    d = 'd'
  []
  [fracture_properties]
    type = ADFractureMaterial
    d = 'd'
    local_dissipation_norm = 8/3
  []
  # [fracture_properties]
  #   type = ADDynamicFractureMaterial
  #   d = 'd'
  #   local_dissipation_norm = 8/3
  # []
  [degradation]
    type = LorentzDegradation
    d = 'd'
    residual_degradation = 0
  []
  [gamma]
    type = CrackSurfaceDensity
    d = 'd'
    local_dissipation_norm = 8/3
  []
[]

# [NodalKernels]
#   [ux]
#     type = PenaltyDirichletNodalKernel
#     penalty = 1e16
#     variable = 'disp_x'
#     boundary = 'ctip'
#   []
# []

[BCs]
  [top_BC]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'top'
    value = 0.10
    use_displaced_mesh = false
  []
  [fix_y]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'center'
    value = 0.0
    use_displaced_mesh = false
  []
  # [fix_x]
  #   type = ADDirichletBC
  #   variable = 'disp_x'
  #   boundary = 'right'
  #   value = 0.0
  # []
[]

[Postprocessors]
  [elastic_energy] # The degraded energy
    type = ADStrainEnergy
  []
  [kinetic_energy]
    type = ADKineticEnergy
  []
  [fracture_energy]
    type = ADFractureEnergy
    d = 'd'
  []
  [explicit_dt]
    type = ADBetterCriticalTimeStep
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
  [d7]
    type = FindValueOnLine
    v = d
    target = 0.7
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d5]
    type = FindValueOnLine
    v = d
    target = 0.5
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d3]
    type = FindValueOnLine
    v = d
    target = 0.3
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []

  [d_vel7]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.7
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d_vel5]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.5
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d_vel3]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.3
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'

  # dt = 1e-7
  end_time = 1e-4

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-6
  l_max_its = 100
  nl_max_its = 100
  [TimeStepper]
    type = PostprocessorDT
    postprocessor = 'explicit_dt'
    scale = 1
  []
  [TimeIntegrator]
    type = NewmarkBeta
    beta = '${beta}'
    gamma = '${gamma}'
  []
[]

[Outputs]
  [Exodus]
    type = Exodus
    file_base = 'output/dynamic_pmma'
    output_material_properties = true
    show_material_properties = 'E_el_active energy_release_rate dissipation_modulus crack_inertia '
                               'mobility'
    # interval = 10
  []
  [CSV]
    type = CSV
    file_base = 'output/dynamic_pmma_pp'
  []
[]
