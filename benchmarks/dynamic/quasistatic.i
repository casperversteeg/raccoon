E = 2.1e5
nu = 0.3

# sigmac = 1.5e-6
Gc = 2.7
l = 0.02
psic = 14.88

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'mesh/quasistatic_geom.msh'
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
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
  []
  [solid_y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
  []

  [pff_inertia]
    type = ADDynamicPFFInertia
    use_displaced_mesh = false
    variable = 'd'
  []
  [pff_grad]
    type = ADDynamicPFFGradientTimeDerivative
    variable = 'd'
  []
  [pff_diff]
    type = ADDynamicPFFDiffusion
    variable = 'd'
  []
  [pff_barr]
    type = ADDynamicPFFBarrier
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
    prop_names = 'phase_field_regularization_length critical_fracture_energy'
    prop_values = '${l} ${psic}'
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
    type = ADQuadraticEnergyReleaseRate
    d = 'd'
    static_fracture_energy = '${Gc}'
    limiting_crack_speed = 1000
  []
  [local_dissipation]
    type = PolynomialLocalDissipation
    coefficients = '0 2 -1'
    d = 'd'
  []
  [fracture_properties]
    type = ADDynamicFractureMaterial
    d = 'd'
    local_dissipation_norm = '3.14159265358979'
  []
  [degradation]
    type = WuDegradation
    d = 'd'
    residual_degradation = 0
    a2 = '-0.5'
    a3 = 0
  []
  [gamma]
    type = CrackSurfaceDensity
    d = 'd'
    local_dissipation_norm = '3.14159265358979'
  []
[]

[BCs]
  [displ_top]
    type = ADFunctionDirichletBC
    boundary = 'top'
    variable = 'disp_y'
    function = 't'
    use_displaced_mesh = false
  []
  [y_disp]
    type = ADDirichletBC
    boundary = 'bottom'
    variable = 'disp_y'
    value = 0
    use_displaced_mesh = false
  []
  [x_disp]
    type = ADDirichletBC
    boundary = 'top bottom'
    variable = 'disp_x'
    value = 0
    use_displaced_mesh = false
  []
[]

[Postprocessors]
  [elastic_energy] # The degraded energy
    type = ADStrainEnergy
  []
  [fracture_energy]
    type = ADFractureEnergy
    d = 'd'
  []
  [d7]
    type = FindValueOnLine
    v = d
    target = 0.7
    start_point = '0 0 0'
    end_point = '0.5 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d5]
    type = FindValueOnLine
    v = d
    target = 0.5
    start_point = '0 0 0'
    end_point = '0.5 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d3]
    type = FindValueOnLine
    v = d
    target = 0.3
    start_point = '0 0 0'
    end_point = '0.5 0 0'
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
    end_point = '0.5 0 0'
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
    end_point = '0.5 0 0'
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
    end_point = '0.5 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
[]

[Problem]
  type = FixedPointProblem
[]

[Executioner]
  type = FixedPointTransient
  solve_type = 'NEWTON'

  dt = 1e-4
  end_time = 10e-3
  # line_search = none
  automatic_scaling = true
  compute_scaling_once = false

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  l_max_its = 100
  nl_max_its = 100

  accept_on_max_fp_iteration = true
  fp_max_its = 1
  fp_tol = 1e-4
  [TimeIntegrator]
    type = NewmarkBeta
  []
[]

[Outputs]
  print_linear_residuals = false
  [Exodus]
    type = Exodus
    file_base = 'output/quasistatic'
    output_material_properties = true
    show_material_properties = 'E_el_active energy_release_rate crack_speed mobility crack_inertia '
                               'dissipation_modulus'
    # interval = 10
  []
  [Console]
    type = Console
    outlier_variable_norms = false
    # interval = 10
  []
  [CSV]
    type = CSV
    file_base = 'output/quasistatic_pp'
  []
[]
