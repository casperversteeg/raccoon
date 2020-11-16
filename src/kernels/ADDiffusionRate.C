//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDiffusionRate.h"

registerMooseObject("raccoonApp", ADDiffusionRate);

InputParameters
ADDiffusionRate::validParams()
{
  auto params = ADKernelGrad::validParams();
  params.addClassDescription("Same as `Diffusion` in terms of physics/residual, but the Jacobian "
                             "is computed using forward automatic differentiation");

  params.addParam<Real>("mu", 1., "");
  return params;
}

ADDiffusionRate::ADDiffusionRate(const InputParameters & parameters)
  : ADKernelGrad(parameters), _grad_u_dot(_var.adGradSlnDot()), _mu(getParam<Real>("mu"))
{
}

ADRealVectorValue
ADDiffusionRate::precomputeQpResidual()
{
  return _mu * _grad_u_dot[_qp];
}
