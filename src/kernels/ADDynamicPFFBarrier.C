//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFBarrier.h"

registerADMooseObject("raccoonApp", ADDynamicPFFBarrier);

InputParameters
ADDynamicPFFBarrier::validParams()
{
  InputParameters params = ADPFFBarrier::validParams();
  params.addClassDescription("computes the reaction term in phase-field evolution equation");
  params.addParam<MaterialPropertyName>("mobility_name", "mobility", "name of mobility");
  params.addParam<MaterialPropertyName>(
      "crack_speed_name", "crack_speed", "name of crack speed material property");
  return params;
}

ADDynamicPFFBarrier::ADDynamicPFFBarrier(const InputParameters & parameters)
  : ADPFFBarrier(parameters),
    _v_name(getParam<MaterialPropertyName>("crack_speed_name")),
    _crack_speed(getADMaterialProperty<Real>(_v_name)),
    _dM(getADMaterialProperty<Real>(
        derivativePropertyNameFirst(getParam<MaterialPropertyName>("mobility_name"), _v_name)))
{
}

ADReal
ADDynamicPFFBarrier::precomputeQpResidual()
{
  return _dw_dd[_qp] * (_M[_qp] + _dM[_qp] * _crack_speed[_qp]);
}
