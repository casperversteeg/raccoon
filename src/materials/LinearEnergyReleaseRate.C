//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "LinearEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", LinearEnergyReleaseRate);
registerMooseObject("raccoonApp", ADLinearEnergyReleaseRate);

template <bool is_ad>
InputParameters
LinearEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
LinearEnergyReleaseRateTempl<is_ad>::LinearEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
LinearEnergyReleaseRateTempl<is_ad>::computeGc()
{
  // ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  // _Gc[_qp] = _Gc0 * (1 + (v / _v_lim));
  // _dGc_dv[_qp] = _Gc0 / _v_lim / _v_lim;
  // _d2Gc_dv2[_qp] = 0.0;
  _Gc[_qp] = _Gc0 * (1 + 2 * std::abs(_gamma_dot[_qp]));
  _dGc_dv[_qp] = 0.0;
  _d2Gc_dv2[_qp] = 0.0;
}

// template class LinearEnergyReleaseRateTempl<false>;
template class LinearEnergyReleaseRateTempl<true>;
