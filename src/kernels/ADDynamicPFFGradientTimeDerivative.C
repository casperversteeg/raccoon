//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFGradientTimeDerivative.h"

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
  params.addParam<bool>("lag_crack_speed",
                        false,
                        "Whether to use the crack speed from the previous step in this solve");

  return params;
}

ADDynamicPFFGradientTimeDerivative::ADDynamicPFFGradientTimeDerivative(
    const InputParameters & parameters)
  : ADKernelValue(parameters),
    _grad_d_dot(_var.adGradSlnDot()),
    _v_name(getParam<MaterialPropertyName>("crack_speed_name")),
    _lag_v(getParam<bool>("lag_crack_speed")),
    _crack_speed(!_lag_v ? &getADMaterialProperty<Real>(_v_name) : nullptr),
    _crack_speed_old(_lag_v ? &getMaterialPropertyOld<Real>(_v_name) : nullptr),
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
<<<<<<< HEAD
  if (_grad_u[_qp].norm() > 0.0)
=======
  if (_grad_u[_qp].norm() > TOLERANCE)
>>>>>>> stagger swagger matters naught
  {
<<<<<<< HEAD
    ADReal coef = _kappa[_qp] * _dM[_qp] - _dissipation[_qp] + _inertia[_qp] * _crack_speed[_qp];
    return -coef * (_grad_u[_qp] * _grad_d_dot[_qp]) / _grad_u[_qp].norm();
=======
    ADReal V;
    if (_lag_v)
      V = (*_crack_speed_old)[_qp];
    else
      V = (*_crack_speed)[_qp];
    ADReal coef = _kappa[_qp] * _dM[_qp] - _dissipation[_qp] - _inertia[_qp] * V;
    return coef * (_grad_u[_qp] * _grad_d_dot[_qp]) / _grad_u[_qp].norm();
>>>>>>> stagger swagger improved lagger
  }
  else
  {
    return 0.0;
  }
}
