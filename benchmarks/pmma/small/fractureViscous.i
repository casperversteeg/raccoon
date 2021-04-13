[Mesh]
  file = 'output/dynamic_pmma_static.e'
[]

[Variables]
  [d]
  []
[]

[AuxVariables]
  [E_el_active]
    family = MONOMIAL
  []
  [bounds_dummy]
  []
[]

[AuxKernels]
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
  [pff_difrate]
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
  [pff_visc]
    type = CoefTimeDerivative
    variable = 'd'
    Coefficient = 1e-7
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
    limiting_crack_speed = '${vlim}'
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
    type = CrackSurfaceDensityDot
    d = 'd'
    local_dissipation_norm = 8/3
  []
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
