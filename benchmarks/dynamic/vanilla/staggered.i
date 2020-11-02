E = 32e3
rho = 2450e-12
nu = 0.2

# sigmac = 1.5e-6
Gc = 0.003
l = 0.625
psic = 1.4822e-4

vlim = 2e8
label = 'vanilla'

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/dynamic_branching_geom.msh'
  []
[]

[MultiApps]
  [fracture]
    type = TransientMultiApp
    input_files = 'fracture.i'
    cli_args = 'Gc=${Gc};l=${l};psic=${psic};vlim=${vlim}'
    sub_cycling = true
    # catch_up = true
  []
[]

[Transfers]
  [from_d]
    type = MultiAppCopyTransfer
    multi_app = 'fracture'
    direction = from_multiapp
    source_variable = 'd'
    variable = 'd'
  []
  # [from_d_vel]
  #   type = MultiAppCopyTransfer
  #   multi_app = 'fracture'
  #   direction = from_multiapp
  #   source_variable = 'd_vel'
  #   variable = 'd_vel'
  # []
  [to_E_el_active]
    type = MultiAppCopyTransfer
    multi_app = 'fracture'
    direction = to_multiapp
    source_variable = 'E_el_active'
    variable = 'E_el_active'
  []
[]

[Variables]
  [disp_x]
  []
  [disp_y]
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
  [E_el_active]
    family = MONOMIAL
  []
  [d]
  []
  [d_vel]
    order = CONSTANT
    family = MONOMIAL
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

  [inertia_x]
    type = ADInertialForce
    variable = disp_x
    use_displaced_mesh = false
  []
  [inertia_y]
    type = ADInertialForce
    variable = disp_y
    use_displaced_mesh = false
  []
[]

[AuxKernels]
  [E_el_active]
    type = ADMaterialRealAux
    variable = 'E_el_active'
    property = 'E_el_active'
  []
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
    prop_names = 'phase_field_regularization_length critical_fracture_energy density'
    prop_values = '${l} ${psic} ${rho}'
    implicit = false
  []
  [elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = '${E}'
    poissons_ratio = '${nu}'
    implicit = false
  []
  [stress]
    type = SmallStrainDegradedElasticPK2Stress_StrainVolDev
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
  [traction_top]
    type = ADPressure
    boundary = 'top'
    variable = 'disp_y'
    component = 1
    constant = -1
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
  [elastic_energy] # The degraded energy
    type = ADStrainEnergy
  []
  [kinetic_energy]
    type = ADKineticEnergy
  []
  [explicit_dt]
    type = ADBetterCriticalTimeStep
    density_name = 'density'
    execute_on = 'INITIAL TIMESTEP_END'
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

[Executioner]
  type = Transient
  # solve_type = 'NEWTON'

  dt = 1e-7
  end_time = 80e-6

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-10
  # l_max_its = 100
  nl_max_its = 100

  [TimeStepper]
    type = PostprocessorDT
    postprocessor = 'explicit_dt'
    scale = 0.9
  []
  [TimeIntegrator]
    type = CentralDifference
    solve_type = lumped
  []
  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]

[Outputs]
  print_linear_residuals = false
  [Exodus]
    type = Exodus
    file_base = 'output/dynamic_branching_staggered_${label}'
    output_material_properties = true
    show_material_properties = 'energy_release_rate dissipation_modulus crack_inertia crack_speed '
    interval = 10
  []
  [Console]
    type = Console
    outlier_variable_norms = false
    # interval = 10
  []
  [CSV]
    type = CSV
    file_base = 'output/dynamic_branching_staggered_${label}_pp'
  []
[]
