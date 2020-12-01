E = 3.09e3
rho = 1180e-12
nu = 0.35

# sigmac = 75
psic = 0.91
Gc = 0.3
l = 0.04

alpha = -0.3
beta = 0.4225
gamma = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  file = 'output/dynamic_pmma_static.e'
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

  [pff_difrate]
    type = ADDiffusionRate
    variable = 'd'
    mu = 0
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
[]

[Materials]
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'density phase_field_regularization_length critical_fracture_energy'
    prop_values = '${rho} ${l} ${psic}'
    implicit = false
  []
  [elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = '${E}'
    poissons_ratio = '${nu}'
    implicit = false
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
    type = ADDynamicFractureMaterial
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
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

# [Problem]
#   type = FixedPointProblem
# []

[Executioner]
  type = Transient
  # type = FixedPointTransient
  solve_type = 'NEWTON'

  dt = 1e-8
  end_time = 1e-4

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-10
  nl_max_its = 100

  # accept_on_max_fp_iteration = true
  # fp_max_its = 100
  # fp_tol = 1e-4
  automatic_scaling = true
  compute_scaling_once = false
  # [TimeStepper]
  #   type = PostprocessorDT
  #   postprocessor = 'explicit_dt'
  #   scale = 1
  # []
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
                               'mobility crack_speed'
    # interval = 10
  []
  [CSV]
    type = CSV
    file_base = 'output/dynamic_pmma_pp'
  []
[]
