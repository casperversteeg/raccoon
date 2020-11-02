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
  params.addParam<bool>("lag_crack_speed",
                        false,
                        "Whether to use the crack speed from the previous step in this solve");
  return params;
}

ADDynamicPFFBarrier::ADDynamicPFFBarrier(const InputParameters & parameters)
  : ADPFFBarrier(parameters),
    _v_name(getParam<MaterialPropertyName>("crack_speed_name")),
    _lag_v(getParam<bool>("lag_crack_speed")),
    _crack_speed(!_lag_v ? &getADMaterialProperty<Real>(_v_name) : nullptr),
    _crack_speed_old(_lag_v ? &getMaterialPropertyOld<Real>(_v_name) : nullptr),
    _dM(getADMaterialProperty<Real>(
        derivativePropertyNameFirst(getParam<MaterialPropertyName>("mobility_name"), _v_name)))
{
}

ADReal
ADDynamicPFFBarrier::precomputeQpResidual()
{
  ADReal V;
  if (_lag_v)
    V = (*_crack_speed_old)[_qp];
  else
    V = (*_crack_speed)[_qp];
  return _dw_dd[_qp] * (_M[_qp] + _dM[_qp] * V);
}
