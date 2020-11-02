//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFGradientTimeDerivative.h"
#include "libmesh/libmesh_common.h"

registerADMooseObject("raccoonApp", ADDynamicPFFGradientTimeDerivative);

InputParameters
ADDynamicPFFGradientTimeDerivative::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription(
      "Computes the gradient terms in dynamic phase-field evolution equation");
  params.addParam<MaterialPropertyName>(
      "crack_speed_name", "crack_speed", "Name of the material property containing crack speed.");
  params.addParam<MaterialPropertyName>(
      "kappa_name", "kappa", "Name of the material property containing $\\kappa$");
  params.addParam<MaterialPropertyName>("mobility_name", "mobility", "Name of mobility");
  params.addParam<MaterialPropertyName>(
      "crack_inertia_name", "crack_inertia", "Name of crack inertia");
  params.addParam<MaterialPropertyName>(
      "dissipation_modulus_name", "dissipation_modulus", "Name of dissipation modulus");

  return params;
}

ADDynamicPFFGradientTimeDerivative::ADDynamicPFFGradientTimeDerivative(
    const InputParameters & parameters)
  : ADKernelValue(parameters),
    _grad_d_dot(_var.gradSlnDot()),
    _v_name(getParam<MaterialPropertyName>("crack_speed_name")),
    _crack_speed(getADMaterialProperty<Real>(_v_name)),
    _kappa(getADMaterialProperty<Real>("kappa_name")),
    _dM(getADMaterialProperty<Real>(
        derivativePropertyNameFirst(getParam<MaterialPropertyName>("mobility_name"), _v_name))),
    _inertia(getADMaterialProperty<Real>("crack_inertia_name")),
    _dissipation(getADMaterialProperty<Real>("dissipation_modulus_name"))
{
}

ADReal
ADDynamicPFFGradientTimeDerivative::precomputeQpResidual()
{
  if (_grad_u[_qp].norm() > TOLERANCE)
  {
    ADReal coef = _kappa[_qp] * _dM[_qp] - _dissipation[_qp] - _inertia[_qp] * _crack_speed[_qp];
    return coef * (_grad_u[_qp] * _grad_d_dot[_qp]) / _grad_u[_qp].norm();
  }
  else
  {
    return 0.0;
  }
}
