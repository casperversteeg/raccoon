//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFDiffusion.h"

registerADMooseObject("raccoonApp", ADDynamicPFFDiffusion);

InputParameters
ADDynamicPFFDiffusion::validParams()
{
  InputParameters params = ADPFFDiffusion::validParams();
  params.addClassDescription("Computes diffusion term in dynamic phase-field evolution equation, "
                             "where the diffusivity is rate-dependent.");
  params.addParam<MaterialPropertyName>(
      "crack_speed_name", "crack_speed", "Name of material property containing the crack speed.");
  params.addParam<MaterialPropertyName>("dissipation_modulus_name",
                                        "dissipation_modulus",
                                        "Name of the material property containing dissipation");

  return params;
}

ADDynamicPFFDiffusion::ADDynamicPFFDiffusion(const InputParameters & parameters)
  : ADPFFDiffusion(parameters),
    _crack_speed(getADMaterialProperty<Real>("crack_speed_name")),
    _dissipation(getADMaterialProperty<Real>("dissipation_modulus_name"))
{
}

ADReal
ADDynamicPFFDiffusion::computeQpResidual()
{
  ADReal residual =
      _grad_test[_i][_qp](0) * _grad_u[_qp](0) + _grad_test[_i][_qp](1) * _grad_u[_qp](1);
  if (_coord_sys == Moose::COORD_RZ)
    residual -= _test[_i][_qp] / _ad_q_point[_qp](0) * _grad_u[_qp](0);
  else
    residual += _grad_test[_i][_qp](2) * _grad_u[_qp](2);

  return (_dissipation[_qp] * _crack_speed[_qp] + _M[_qp] * _kappa[_qp]) * residual;
}
