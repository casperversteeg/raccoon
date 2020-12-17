E = 1
rho = 1
nu = 0

# sigmac = 1.5
psic = 1.125
Gc = 0.45
l = 0.021

mu = 0.0

alpha = -0.3
# beta = 0.25
# gamma = 0.5
beta = 0.4225
gamma = 0.8

[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = 400
  []
[]

[GlobalParams]
  displacements = 'disp_x'
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
  [d]
    [InitialCondition]
      type = BoundingBoxIC
      variable = 'd'
      x1 = -0.1
      x2 = 0.025
      y1 = -0.1
      y2 = 0.1
      inside = 1
    []
  []
[]

[AuxVariables]
  [stress]
    order = CONSTANT
    family = MONOMIAL
  []
  [bounds_dummy]
  []
  [vel_x]
  []
  [d_dot]
  []
  [grad_d_dot]
    order = CONSTANT
    family = MONOMIAL
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
    bound_type = upper
    bound_value = 1
  []
[]

[Kernels]
  [solid_x]
    type = ADDynamicStressDivergenceTensors
    variable = disp_x
    component = 0
    alpha = '${alpha}'
  []
  [inertia_x]
    type = ADInertialForce
    variable = disp_x
    use_displaced_mesh = false
    alpha = '${alpha}'
  []

  [pff_laplacerate]
    type = ADDiffusionRate
    variable = 'd'
    mu = '${mu}'
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
  [stress]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress
    index_i = 0
    index_j = 0
  []
  [vx]
    type = TestNewmarkTI
    variable = 'vel_x'
    displacement = 'disp_x'
    execute_on = 'TIMESTEP_END'
  []
  [ddot]
    type = TestNewmarkTI
    variable = 'd_dot'
    displacement = 'd'
    execute_on = 'TIMESTEP_END'
  []
  [grad_ddot]
    type = VariableGradientComponent
    variable = 'grad_d_dot'
    gradient_variable = 'd_dot'
    component = 'x'
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
    limiting_crack_speed = 2e8
    lag_crack_speed = true
  []
  # [local_dissipation]
  #   type = PolynomialLocalDissipation
  #   coefficients = '0 2 -1'
  #   d = 'd'
  # []
  [local_dissipation]
    type = QuadraticLocalDissipation
    d = 'd'
  []
  [fracture_properties]
    type = ADDynamicFractureMaterial
    d = 'd'
    local_dissipation_norm = '2'
  []
  [degradation]
    type = QuadraticDegradation
    d = 'd'
    residual_degradation = 0
  []
  # [degradation]
  #   type = WuDegradation
  #   d = 'd'
  #   residual_degradation = 0
  #   a2 = '-0.5'
  #   a3 = 0
  # []
  # [gamma]
  #   type = CrackSurfaceDensityDot
  #   d = 'd'
  #   local_dissipation_norm = '3.14159265358979'
  # []
  # [local_dissipation]
  #   type = LinearLocalDissipation
  #   d = 'd'
  # []
  # [fracture_properties]
  #   type = ADDynamicFractureMaterial
  #   d = 'd'
  #   local_dissipation_norm = 8/3
  # []
  # [degradation]
  #   type = LorentzDegradation
  #   d = 'd'
  #   residual_degradation = 0
  # []
  [gamma]
    type = CrackSurfaceDensityDot
    d = 'd'
    local_dissipation_norm = 2
  []
[]

[Functions]
  [step1]
    type = SmoothStep
    t_end = 0.1
    y_end = 2
    N = 2
  []
  [step2]
    type = SmoothStep
    t_end = 0.1
    y_end = 2
    N = 2
    t_offset = 0.5
  []
  [step]
    type = LinearCombinationFunction
    functions = 'step1 step2'
    w = '1 -1'
  []
[]

[BCs]
  [left]
    type = ADDirichletBC
    boundary = left
    variable = 'disp_x'
    value = 0.0
  []
  # [right]
  #   type = ADPressure
  #   boundary = right
  #   variable = 'disp_x'
  #   function = 'step'
  #   component = 0
  #   constant = 1
  #   alpha = '${alpha}'
  #   use_displaced_mesh = false
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
  [total_energy]
    type = LinearCombinationPostprocessor
    pp_coefs = '1 1 1'
    pp_names = 'elastic_energy kinetic_energy fracture_energy'
  []
[]

[Executioner]
  type = Transient
  # dt = 1e-3 #CFL condition
  dt = 0.005
  num_steps = 2
  solve_type = 'NEWTON'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  l_max_its = 50
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
    file_base = 'mechanical_fracture1d_gamma'
    output_material_properties = true
    show_material_properties = 'E_el_active crack_speed gamma gamma_dot'
  []
  [Console]
    type = Console
    outlier_variable_norms = false
    interval = 10
  []
  [csv]
    type = CSV
    file_base = 'mechanical_fracture1d_energies_gamma'
  []
[]
