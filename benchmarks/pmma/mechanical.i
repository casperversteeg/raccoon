E = 3.09e3
rho = 1180e-12
nu = 0.35

# sigmac = 75
psic = 0.91
Gc = 3
l = 0.4

vlim = 6e8

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  file = 'output/dynamic_pmma_static.e'
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
    initial_from_file_var = 'disp_x'
    # inital_from_file_timestep
  []
  [disp_y]
    initial_from_file_var = 'disp_y'
  []
[]

[AuxVariables]
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
  [d]
  []
  [d_vel]
    order = CONSTANT
    family = MONOMIAL
  []
  [E_el_active]
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
[]

[Kernels]
  [solid_x]
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
    static_initialization = true
    # alpha = '${alpha}'
  []
  [solid_y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
    static_initialization = true
    # alpha = '${alpha}'
  []
  [inertia_x]
    type = ADInertialForce
    variable = disp_x
    use_displaced_mesh = false
    # alpha = '${alpha}'
  []
  [inertia_y]
    type = ADInertialForce
    variable = disp_y
    use_displaced_mesh = false
    # alpha = '${alpha}'
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
    type = CrackSurfaceDensity
    d = 'd'
    local_dissipation_norm = 8/3
  []
[]

[BCs]
  [top_BC]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'top'
    value = 0.06
    use_displaced_mesh = false
  []
  [fix_y]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'center'
    value = 0.0
    use_displaced_mesh = false
  []
  [fix_x]
    type = ADDirichletBC
    variable = 'disp_x'
    boundary = 'right'
    value = 0.0
    use_displaced_mesh = false
  []
[]

[Postprocessors]
  [elastic_energy] # The degraded energy
    type = ADStrainEnergy
  []
  [kinetic_energy]
    type = KineticEnergy
  []
  [fracture_energy]
    type = ADFractureEnergy
    d = 'd'
  []
  [explicit_dt]
    type = ADBetterCriticalTimeStep
    density_name = 'dens_ad'
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
  [d7]
    type = FindValueOnLine
    v = d
    target = 0.7
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d5]
    type = FindValueOnLine
    v = d
    target = 0.5
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d3]
    type = FindValueOnLine
    v = d
    target = 0.3
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []

  [d_vel7]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.7
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d_vel5]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.5
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
  [d_vel3]
    type = FindValueOnLineByFVOL
    v = d
    w = d_vel
    target = 0.3
    start_point = '-12 0 0'
    end_point = '16 0 0'
    depth = 100
    error_if_not_found = false
    default_value = 0
  []
[]

[Executioner]
  type = Transient
  end_time = 1e-4
  # solve_type = 'NEWTON'

  nl_abs_tol = 1e-6
  l_abs_tol = 1e-10
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  [TimeStepper]
    type = PostprocessorDT
    postprocessor = 'explicit_dt'
    scale = 0.9
  []
  [TimeIntegrator]
    # type = NewmarkBeta
    # beta = '${beta}'
    # gamma = '${gamma}'
    type = CentralDifference
    solve_type = lumped
  []
  # [Quadrature]
  #   order = FIRST
  # []
[]

[Outputs]
  # print_linear_residuals = false
  # hide = 'explicit_dt'
  [Exodus]
    type = Exodus
    file_base = 'output/dynamic_pmma'
    output_material_properties = true
    show_material_properties = 'energy_release_rate dissipation_modulus crack_inertia mobility '
                               'crack_speed'
    interval = 10
  []
  [CSV]
    type = CSV
    file_base = 'output/dynamic_pmma_pp'
  []
[]
