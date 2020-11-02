E = 32e3
rho = 2450e-12
nu = 0.2

# sigmac = 1.5e-6
Gc = 0.003
l = 0.625
psic = 1.4822e-4

label = 'nonvariational'

alpha = -0.3
beta = 0.4225
gamma = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/dynamic_branching_geom.msh'
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
  []
  [disp_y]
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
    component = 0
    alpha = '${alpha}'
  []
  [solid_y]
    type = ADDynamicStressDivergenceTensors
    variable = disp_y
    component = 1
    alpha = '${alpha}'
  []

  [inertia_x]
    type = InertialForce
    variable = disp_x
    alpha = '${alpha}'
    use_displaced_mesh = false
  []
  [inertia_y]
    type = InertialForce
    variable = disp_y
    alpha = '${alpha}'
    use_displaced_mesh = false
  []

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
    type = CrackVelocityAux
    variable = 'd_vel'
    d = 'd'
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  [dens]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '${rho}'
  []
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'phase_field_regularization_length critical_fracture_energy dens_ad'
    prop_values = '${l} ${psic} ${rho}'
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
    type = ADLogarithmicEnergyReleaseRate
    d = 'd'
    static_fracture_energy = '${Gc}'
<<<<<<< HEAD
    limiting_crack_speed = 1e6
=======
    limiting_crack_speed = 2e8
    lag_crack_speed = true
>>>>>>> stagger swagger matters naught
  []
  [local_dissipation]
    type = LinearLocalDissipation
    d = 'd'
  []
  [fracture_properties]
    type = ADDynamicFractureMaterial
    d = 'd'
    local_dissipation_norm = 8/3
  []
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

[BCs]
  [traction_top]
    type = ADPressure
    boundary = 'top'
    variable = 'disp_y'
    component = 1
    constant = -1
    alpha = '${alpha}'
    use_displaced_mesh = false
  []
  [y_disp]
    type = ADDirichletBC
    boundary = 'center'
    variable = 'disp_y'
    value = 0
    use_displaced_mesh = false
  []
[]

[Postprocessors]
  [explicit_dt]
    type = ADBetterCriticalTimeStep
    density_name = 'dens_ad'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [d7]
    type = FindValueOnLine
    v = d
    target = 0.7
    start_point = '0 0 0'
    end_point = '50 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d5]
    type = FindValueOnLine
    v = d
    target = 0.5
    start_point = '0 0 0'
    end_point = '50 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d3]
    type = FindValueOnLine
    v = d
    target = 0.3
    start_point = '0 0 0'
    end_point = '50 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []

  [d_vel7]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.7
    start_point = '0 0 0'
    end_point = '50 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d_vel5]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.5
    start_point = '0 0 0'
    end_point = '50 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d_vel3]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.3
    start_point = '0 0 0'
    end_point = '50 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
[]

# [Problem]
#   type = FixedPointProblem
# []

[Executioner]
  type = Transient
  solve_type = 'NEWTON'

  dt = 1e-7
  end_time = 80e-6

  # accept_on_max_fp_iteration = true
  # fp_max_its = 100
  # fp_tol = 1e-4

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-10
  # l_max_its = 100
  nl_max_its = 100

  [TimeIntegrator]
    type = NewmarkBeta
    beta = '${beta}'
    gamma = '${gamma}'
  []
[]

[Outputs]
  print_linear_residuals = false
  [Exodus]
    type = Exodus
    file_base = '../output/dynamic_branching_${label}'
    output_material_properties = true
    show_material_properties = 'E_el_active energy_release_rate'
    interval = 10
  []
  [Console]
    type = Console
    outlier_variable_norms = false
    # interval = 10
  []
  [CSV]
    type = CSV
    file_base = '../output/dynamic_branching_${label}_pp'
  []
[]
