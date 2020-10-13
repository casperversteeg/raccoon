//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFGradient.h"

registerADMooseObject("raccoonApp", ADDynamicPFFGradient);

InputParameters
ADDynamicPFFGradient::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription(
      "Computes the gradient terms in dynamic phase-field evolution equation");
  params.addParam<MaterialPropertyName>("energy_release_rate_name",
                                        "energy_release_rate",
                                        "Name of the material property containing Gc.");
  params.addParam<MaterialPropertyName>("phase_field_regularization_length_name",
                                        "phase_field_regularization_length",
                                        "Name of the material property containing $\\ell$");
  params.addParam<MaterialPropertyName>("local_dissipation_name", "w", "Name of local dissipation");
  params.addRequiredParam<FunctionName>("local_dissipation_norm",
                                        "norm of the local dissipation ||w(d)||");

  return params;
}

ADDynamicPFFGradient::ADDynamicPFFGradient(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _d_dot(_var.adUDot()),
    _grad_d_dot(_var.gradSlnDot()),
    _Gc(getADMaterialProperty<Real>("energy_release_rate_name")),
    _d2Gc_dv2(getADMaterialProperty<Real>(derivativePropertyNameSecond(
        getParam<MaterialPropertyName>("energy_release_rate_name"), "crack_speed", "crack_speed"))),
    _ell(getADMaterialProperty<Real>("phase_field_regularization_length_name")),
    _w(getADMaterialProperty<Real>("local_dissipation_name")),
    _w_norm(getFunction("local_dissipation_norm"))
{
}

ADReal
ADDynamicPFFGradient::precomputeQpResidual()
{
  if (_grad_u[_qp].norm() > 0.0)
  {
    Real c0 = _w_norm.value(_t, _q_point[_qp]);
    ADReal gamma =
        1 / c0 / _ell[_qp] * (_w[_qp] + _ell[_qp] * _ell[_qp] * _grad_u[_qp] * _grad_u[_qp]);

    ADReal D = _Gc[_qp] / c0 *
               (_w[_qp] / _ell[_qp] / _grad_u[_qp].norm() / _grad_u[_qp].norm() - _ell[_qp]);
    D += gamma * _d2Gc_dv2[_qp] / std::pow(_grad_u[_qp].norm(), 3) * _d_dot[_qp];

    return D * _grad_u[_qp] * _grad_d_dot[_qp] / _grad_u[_qp].norm();
  }
  else
    return 0.0;
}
