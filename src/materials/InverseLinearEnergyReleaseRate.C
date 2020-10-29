//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "InverseLinearEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", InverseLinearEnergyReleaseRate);
registerMooseObject("raccoonApp", ADInverseLinearEnergyReleaseRate);

template <bool is_ad>
InputParameters
InverseLinearEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
InverseLinearEnergyReleaseRateTempl<is_ad>::InverseLinearEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
InverseLinearEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  ADReal den = 1 - v / _v_lim;
  _Gc[_qp] = _Gc0 / den;
  _dGc_dv[_qp] = -_Gc0 / den / den;
  _d2Gc_dv2[_qp] = 2 * _Gc0 / den / den / den;
}

// template class InverseLinearEnergyReleaseRateTempl<false>;
template class InverseLinearEnergyReleaseRateTempl<true>;
