E = 1
rho = 1
nu = 0.25

alpha = -0.3
beta = 0.4225
gamma = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [top]
    type = GeneratedMeshGenerator
    xmax = 0.05
    xmin = -0.05
    ymax = 1
    ymin = 0
    nx = 10
    ny = 100
    dim = 2
    elem_type = QUAD4
  []
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
[]

[AuxVariables]
  [stress_vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
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
  [accel_x]
  []
  [accel_y]
  []
  [vel_x]
  []
  [vel_y]
  []
  [bound_x_dummy1]
  []
  [bound_x_dummy2]
  []
[]

[Bounds]
  [upper]
    type = ConstantBoundsAux
    variable = 'bound_x_dummy1'
    bounded_variable = 'disp_x'
    boundary = 'right'
    bound_type = upper
    bound_value = 0.01
  []
  [lower]
    type = ConstantBoundsAux
    variable = 'bound_x_dummy2'
    bounded_variable = 'disp_x'
    boundary = 'left'
    bound_type = lower
    bound_value = -0.01
  []
[]

[Kernels]
  [solid_x]
    type = ADDynamicStressDivergenceTensors
    variable = disp_x
    component = 0
    static_initialization = true
    alpha = '${alpha}'
  []
  [solid_y]
    type = ADDynamicStressDivergenceTensors
    variable = disp_y
    component = 1
    static_initialization = true
    alpha = '${alpha}'
  []
  [inertia_x]
    type = ADInertialForce
    variable = disp_x
    use_displaced_mesh = false
    alpha = '${alpha}'
  []
  [inertia_y]
    type = ADInertialForce
    variable = disp_y
    use_displaced_mesh = false
    alpha = '${alpha}'
  []
[]

[AuxKernels]
  [VonMises]
    type = ADRankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_vonmises
    scalar_type = 'VonMisesStress'
  []
  [stressxx]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
    execute_on = TIMESTEP_END
  []
  [stressxy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
    execute_on = TIMESTEP_END
  []
  [stressyy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
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
  [ax]
    type = TestNewmarkTI
    variable = 'accel_x'
    displacement = 'disp_x'
    first = false
    execute_on = 'TIMESTEP_END'
  []
  [ay]
    type = TestNewmarkTI
    variable = 'accel_y'
    displacement = 'disp_y'
    first = false
    execute_on = 'TIMESTEP_END'
  []
  [vx]
    type = TestNewmarkTI
    variable = 'vel_x'
    displacement = 'disp_x'
    execute_on = 'TIMESTEP_END'
  []
  [yx]
    type = TestNewmarkTI
    variable = 'vel_y'
    displacement = 'disp_y'
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'density'
    prop_values = '${rho}'
  []
  [elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = '${E}'
    poissons_ratio = '${nu}'
  []
  [stress]
    type = ADComputeLinearElasticStress
  []
  [strain]
    type = ADComputeSmallStrain
  []
[]

[BCs]
  [top_BC]
    type = ADPressure
    variable = 'disp_x'
    boundary = 'right'
    component = 0
    function = '0.1*x*sin(5*t)'
    use_displaced_mesh = false
  []
  [fix_y]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'bottom'
    value = 0.0
    use_displaced_mesh = false
  []
  [fix_x]
    type = ADDirichletBC
    variable = 'disp_x'
    boundary = 'bottom'
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
  [explicit_dt]
    type = ADBetterCriticalTimeStep
    # density_name = 'density'
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

[Executioner]
  type = Transient
  end_time = 30
  solve_type = 'NEWTON'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-6
  l_abs_tol = 1e-10
  [TimeStepper]
    type = PostprocessorDT
    postprocessor = 'explicit_dt'
    scale = 0.95
  []
  [TimeIntegrator]
    type = NewmarkBeta
    beta = '${beta}'
    gamma = '${gamma}'
    # type = CentralDifference
    # solve_type = lumped
    # use_constant_mass = true
  []
  # [Quadrature]
  #   order = FIRST
  # []
[]

[Outputs]
  print_linear_residuals = false
  hide = 'explicit_dt'
  [Exodus]
    type = Exodus
    file_base = 'output/dynamic_pmma'
    interval = 1
  []
  [CSV]
    type = CSV
    file_base = 'output/dynamic_pmma_pp'
    interval = 10
  []
[]
