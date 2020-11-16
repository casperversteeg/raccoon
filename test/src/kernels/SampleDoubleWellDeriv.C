//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "SampleDoubleWellDeriv.h"

registerADMooseObject("raccoonApp", SampleDoubleWellDeriv);

InputParameters
SampleDoubleWellDeriv::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  return params;
}

SampleDoubleWellDeriv::SampleDoubleWellDeriv(const InputParameters & parameters)
  : ADKernelValue(parameters)
{
}

ADReal
SampleDoubleWellDeriv::precomputeQpResidual()
{
  return -2 * _u[_qp] * (1 - 3 * _u[_qp] + 2 * _u[_qp] * _u[_qp]);
}
