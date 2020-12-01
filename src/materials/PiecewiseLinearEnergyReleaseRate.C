//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "PiecewiseLinearEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", PiecewiseLinearEnergyReleaseRate);
registerMooseObject("raccoonApp", ADPiecewiseLinearEnergyReleaseRate);

template <bool is_ad>
InputParameters
PiecewiseLinearEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
PiecewiseLinearEnergyReleaseRateTempl<is_ad>::PiecewiseLinearEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
PiecewiseLinearEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  _Gc[_qp] = _Gc0 * (v < _v_lim ? 1. : (v - _v_lim + 2. * _v_lim) / (2. * _v_lim));
  _dGc_dv[_qp] = (v < _v_lim ? 0.0 : _Gc0 / (2. * _v_lim));
  _d2Gc_dv2[_qp] = 0.0;
}

// template class PiecewiseLinearEnergyReleaseRateTempl<false>;
template class PiecewiseLinearEnergyReleaseRateTempl<true>;
