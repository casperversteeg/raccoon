[Mesh]
  file = '../mesh/dynamic_branching_geom.msh'
[]

[Variables]
  [d]
  []
[]

[AuxVariables]
  [E_el_active]
    family = MONOMIAL
    # order = CONSTANT
  []
  [bounds_dummy]
  []
  # [d_vel]
  #   family = MONOMIAL
  #   order = CONSTANT
  # []
[]

[AuxKernels]
  # [d_vel]
  #   type = ADMaterialRealAux
  #   variable = 'd_vel'
  #   property = 'crack_speed'
  #   execute_on = 'TIMESTEP_END'
  # []
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

[Materials]
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'phase_field_regularization_length critical_fracture_energy'
    prop_values = '${l} ${psic}'
    implicit = false
  []
  [Gc]
    type = ADConstantEnergyReleaseRate
    d = 'd'
    static_fracture_energy = '${Gc}'
    limiting_crack_speed = '${vlim}'
    lag_crack_speed = true
  []
  [local_dissipation]
    type = LinearLocalDissipation
    # coefficients = '0 2 -1'
    d = 'd'
  []
  [fracture_properties]
    type = ADDynamicFractureMaterial
    d = 'd'
    local_dissipation_norm = '8/3'
    # local_dissipation_norm = '3.14159265358979'
  []
  [degradation]
    type = LorentzDegradation
    d = 'd'
    residual_degradation = 0
    # a2 = '-0.5'
    # a3 = 0
  []
  [gamma]
    type = CrackSurfaceDensity
    d = 'd'
    local_dissipation_norm = '8/3'
  []
[]

[Postprocessors]
[]

[Executioner]
  type = Transient

  nl_abs_tol = 1e-6

  solve_type = 'NEWTON'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  automatic_scaling = true
  compute_scaling_once = false

  [Quadrature]
    type = GAUSS
    order = FIRST
  []
[]

[Outputs]
  print_linear_residuals = false
  print_linear_converged_reason = false
[]
