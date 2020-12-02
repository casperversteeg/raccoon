//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "QuadraticEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", QuadraticEnergyReleaseRate);
registerMooseObject("raccoonApp", ADQuadraticEnergyReleaseRate);

template <bool is_ad>
InputParameters
QuadraticEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
QuadraticEnergyReleaseRateTempl<is_ad>::QuadraticEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
QuadraticEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  _Gc[_qp] = _Gc0 * (1 + (v / _v_lim) * (v / _v_lim));
  _dGc_dv[_qp] = 2 * _Gc0 * (v / _v_lim) / _v_lim;
  _d2Gc_dv2[_qp] = 2 * _Gc0 / _v_lim / _v_lim;
}

// template class QuadraticEnergyReleaseRateTempl<false>;
template class QuadraticEnergyReleaseRateTempl<true>;
