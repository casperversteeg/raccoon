# sigmac = 1.5
psic = 1.125
Gc = 0.45
l = 0.02

mu = 0.0

[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = 500
  []
[]

[Variables]
  [d]
  []
[]

[AuxVariables]
  [bounds_d]
  []
  [d_dot]
  []
  [grad_d_dot]
    order = CONSTANT
    family = MONOMIAL
  []
  [grad_d]
    order = CONSTANT
    family = MONOMIAL
  []
  [d_vel]
    order = CONSTANT
    family = MONOMIAL
  []
  [gamma_dot]
    order = CONSTANT
    family = MONOMIAL
  []
  [E_el_active]
  []
[]

[Bounds]
  [irreversibility_d]
    type = VariableOldValueBoundsAux
    variable = 'bounds_d'
    bounded_variable = 'd'
    bound_type = lower
  []
  [upper]
    type = ConstantBoundsAux
    variable = 'bounds_d'
    bounded_variable = 'd'
    bound_type = upper
    bound_value = 1
  []
[]

[Kernels]
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
    driving_energy_var = 'E_el_active'
  []
[]

[AuxKernels]
  [grad_ddot]
    type = VariableGradientComponent
    variable = 'grad_d_dot'
    gradient_variable = 'd_dot'
    component = 'x'
  []
  [grad_d]
    type = VariableGradientComponent
    variable = 'grad_d'
    gradient_variable = 'd'
    component = 'x'
  []
  [d_vel]
    type = ADMaterialRealAux
    variable = 'd_vel'
    property = 'crack_speed'
    execute_on = 'TIMESTEP_END'
  []
  [gamma_dot]
    type = ADMaterialRealAux
    variable = 'gamma_dot'
    property = 'gamma_dot'
    execute_on = 'TIMESTEP_END'
  []
  [E_el_active]
    type = FunctionAux
    variable = 'E_el_active'
    function = 'driving'
  []
[]

[Materials]
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'phase_field_regularization_length critical_fracture_energy'
    prop_values = '${l} ${psic}'
  []
  [Gc]
    type = ADConstantEnergyReleaseRate
    d = 'd'
    static_fracture_energy = '${Gc}'
    limiting_crack_speed = 2e8
    lag_crack_speed = true
  []
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
  [gamma]
    type = CrackSurfaceDensityDot
    d = 'd'
    local_dissipation_norm = '2'
  []
[]

[Functions]
  [driving]
    type = ParsedFunction
    value = 'if((1-exp(-5*t^2))*sin(50*t)^2 - x >= 0, 1e6, 0)'
  []
[]

[Postprocessors]
  [fracture_energy]
    type = ADFractureEnergy
    d = 'd'
  []
[]

[Executioner]
  type = Transient
  # dt = 1e-3 #CFL condition
  dt = 0.00001
  end_time = 1
  solve_type = 'NEWTON'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  l_max_its = 50
  nl_max_its = 100

[]

[Outputs]
  print_linear_residuals = false
  [Exodus]
    type = Exodus
    file_base = 'pseudoparabolic_${mu}'
    output_material_properties = true
    show_material_properties = 'E_el_active crack_speed gamma gamma_dot'
    interval = 10
  []
  [Console]
    type = Console
    outlier_variable_norms = false
    interval = 10
  []
  [csv]
    type = CSV
    file_base = 'pseudoparabolic_energies_${mu}'
  []
[]
