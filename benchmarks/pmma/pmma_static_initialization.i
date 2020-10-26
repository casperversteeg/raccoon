E = 3.09e3
nu = 0.35

geom = 'msh/geom.msh'

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [gmg]
    type = FileMeshGenerator
    file = '${geom}'
  []
[]

[Variables]
  [disp_x]
  []
  [disp_y]
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

[BCs]
  [top_BC]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'top'
    value = 0.06
  []
  [fix_y]
    type = ADDirichletBC
    variable = 'disp_y'
    boundary = 'center'
    value = 0.0
  []
  [fix_x]
    type = ADDirichletBC
    variable = 'disp_x'
    boundary = 'right'
    value = 0.0
  []
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
    file_base = 'output/hai_test_QS'
    # output_material_properties = true
  []
[]
