//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "LogarithmicEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", LogarithmicnergyReleaseRate);
registerMooseObject("raccoonApp", ADLogarithmicEnergyReleaseRate);

template <bool is_ad>
InputParameters
LogarithmicEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
LogarithmicEnergyReleaseRateTempl<is_ad>::LogarithmicEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
LogarithmicEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  _Gc[_qp] = _Gc0 * (1 + std::log(_v_lim / (_v_lim - v)));
  _dGc_dv[_qp] = _Gc0 / (_v_lim - v);
  _d2Gc_dv2[_qp] = _Gc0 / (_v_lim - v) / (_v_lim - v);
}

// template class LogarithmicEnergyReleaseRateTempl<false>;
template class LogarithmicEnergyReleaseRateTempl<true>;
