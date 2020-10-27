[Mesh]
  file = '../output/dynamic_pmma_static.e'
[]

[Variables]
  [d]
  []
[]

[AuxVariables]
  [E_el_active]
    family = MONOMIAL
    order = FIRST
  []
  [bounds_dummy]
  []
  # [d_vel]
  #   family = MONOMIAL
  #   order = CONSTANT
  # []
[]

# [AuxKernels]
#   [dvel]
#     type = CrackVelocityAux
#     variable = 'd_vel'
#     d = 'd'
#     execute_on = 'TIMESTEP_END'
#   []
# []

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
  [pff_hyperbolic]
    type = InertialForce
    use_displaced_mesh = false
    variable = 'd'
    density = 'microcrack_inertia'
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

[Materials]
  [kappa]
    type = GenericConstantMaterial
    prop_names = 'microcrack_inertia'
    prop_values = '${kappa}'
  []
  [const]
    type = ADGenericConstantMaterial
    prop_names = 'phase_field_regularization_length critical_fracture_energy energy_release_rate'
    prop_values = '${l} ${psic} ${Gc}'
  []
  [local_dissipation]
    type = PolynomialLocalDissipation
    coefficients = '0 2 -1'
    d = 'd'
  []
  [fracture_properties]
    type = ADFractureMaterial
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

[Executioner]
  type = Transient

  nl_abs_tol = 1e-6

  solve_type = 'NEWTON'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -snes_type'
  petsc_options_value = 'lu       superlu_dist                  vinewtonrsls'

  automatic_scaling = true
  compute_scaling_once = false

  [TimeIntegrator]
    type = NewmarkBeta
  []
[]

[Outputs]
  print_linear_residuals = false
  print_linear_converged_reason = false
[]
