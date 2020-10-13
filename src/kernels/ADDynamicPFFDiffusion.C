//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFDiffusion.h"

registerADMooseObject("raccoonApp", ADDynamicPFFDiffusion);

InputParameters
ADDynamicPFFDiffusion::validParams()
{
  InputParameters params = ADKernelGrad::validParams();
  params.addClassDescription("Computes diffusion term in dynamic phase-field evolution equation, "
                             "where the diffusivity is rate-dependent.");
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

ADDynamicPFFDiffusion::ADDynamicPFFDiffusion(const InputParameters & parameters)
  : ADKernelGrad(parameters),
    _d_dot(_var.adUDot()),
    _Gc(getADMaterialProperty<Real>("energy_release_rate_name")),
    _dGc_dv(getADMaterialProperty<Real>(derivativePropertyNameFirst(
        getParam<MaterialPropertyName>("energy_release_rate_name"), "crack_speed"))),
    _ell(getADMaterialProperty<Real>("phase_field_regularization_length_name")),
    _w(getADMaterialProperty<Real>("local_dissipation_name")),
    _w_norm(getFunction("local_dissipation_norm"))
{
}

ADRealVectorValue
ADDynamicPFFDiffusion::precomputeQpResidual()
{
  if (_grad_u[_qp].norm() > 0.0)
  {
    Real c0 = _w_norm.value(_t, _q_point[_qp]);
    ADReal gamma =
        1 / c0 / _ell[_qp] * (_w[_qp] + _ell[_qp] * _ell[_qp] * _grad_u[_qp] * _grad_u[_qp]);

    ADReal D = 2 * _ell[_qp] * _Gc[_qp] / c0 -
               gamma * _dGc_dv[_qp] * _d_dot[_qp] / std::pow(_grad_u[_qp].norm(), 3);
    return D * _grad_u[_qp];
  }
  else
    return 0.0;
}
