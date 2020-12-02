//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "CubicEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", CubicEnergyReleaseRate);
registerMooseObject("raccoonApp", ADCubicEnergyReleaseRate);

template <bool is_ad>
InputParameters
CubicEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
CubicEnergyReleaseRateTempl<is_ad>::CubicEnergyReleaseRateTempl(const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
CubicEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  _Gc[_qp] = _Gc0 * (1 + (v / _v_lim) * (v / _v_lim) * (v / _v_lim));
  _dGc_dv[_qp] = 3 * _Gc0 * (v / _v_lim) * (v / _v_lim) / _v_lim;
  _d2Gc_dv2[_qp] = 6 * _Gc0 * (v / _v_lim) / _v_lim / _v_lim;
}

// template class CubicEnergyReleaseRateTempl<false>;
template class CubicEnergyReleaseRateTempl<true>;
