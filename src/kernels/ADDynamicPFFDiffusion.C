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
  params.addParam<bool>("lag_crack_speed",
                        false,
                        "Whether to use the crack speed from the previous step in this solve");

  return params;
}

ADDynamicPFFDiffusion::ADDynamicPFFDiffusion(const InputParameters & parameters)
  : ADPFFDiffusion(parameters),
    _lag_v(getParam<bool>("lag_crack_speed")),
    _crack_speed(!_lag_v ? &getADMaterialProperty<Real>("crack_speed_name") : nullptr),
    _crack_speed_old(_lag_v ? &getMaterialPropertyOld<Real>("crack_speed_name") : nullptr),
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

  ADReal V;
  if (_lag_v)
    V = (*_crack_speed_old)[_qp];
  else
    V = (*_crack_speed)[_qp];

  return (_dissipation[_qp] * V + _M[_qp] * _kappa[_qp]) * residual;
}
