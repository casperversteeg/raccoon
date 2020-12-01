E = 3.09e3
nu = 0.35

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'mesh/pmma.msh'
  []
  [bbnsg]
    type = BoundingBoxNodeSetGenerator
    bottom_left = '-12.01 -0.01 0'
    top_right = '-11.99 0.01 0'
    new_boundary = 'ctip'
    input = fmg
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
[]

[Materials]
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

[NodalKernels]
  [ux]
    type = PenaltyDirichletNodalKernel
    penalty = 1e16
    variable = 'disp_x'
    boundary = 'ctip'
  []
[]

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
  # [fix_x]
  #   type = ADDirichletBC
  #   variable = 'disp_x'
  #   boundary = 'right'
  #   value = 0.0
  #   use_displaced_mesh = false
  # []
[]

[Postprocessors]
  [elastic_energy] # The degraded energy
    type = ADStrainEnergy
  []
[]

[Executioner]
  type = Steady

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'

  solve_type = 'NEWTON'

  nl_abs_tol = 1e-6
  l_abs_tol = 1e-10

[]

[Outputs]
  [Exodus]
    type = Exodus
    file_base = 'output/dynamic_pmma_static'
    # output_material_properties = true
  []
[]
