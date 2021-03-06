//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADPFFBarrier.h"

registerADMooseObject("raccoonApp", ADPFFBarrier);

InputParameters
ADPFFBarrier::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addClassDescription("computes the reaction term in phase-field evolution equation");
  params.addParam<MaterialPropertyName>("mobility_name", "mobility", "name of mobility");
  params.addParam<MaterialPropertyName>("local_dissipation_name", "w", "name of local dissipation");
  return params;
}

ADPFFBarrier::ADPFFBarrier(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _M(getADMaterialProperty<Real>("mobility_name")),
    _dw_dd(getADMaterialProperty<Real>(derivativePropertyNameFirst(
        getParam<MaterialPropertyName>("local_dissipation_name"), _var.name())))
{
}

ADReal
ADPFFBarrier::precomputeQpResidual()
{
  return _dw_dd[_qp] * _M[_qp];
}
