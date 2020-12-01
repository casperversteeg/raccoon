//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "InversePowerEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", InversePowerEnergyReleaseRate);
registerMooseObject("raccoonApp", ADInversePowerEnergyReleaseRate);

template <bool is_ad>
InputParameters
InversePowerEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  params.addParam<Real>("exponent", 1.0, "Exponent on the denominator");
  return params;
}
template <bool is_ad>
InversePowerEnergyReleaseRateTempl<is_ad>::InversePowerEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters),
    _exponent(getParam<Real>("exponent"))
{
}

template <bool is_ad>
void
InversePowerEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  ADReal den = 1 - std::pow(v / _v_lim, _exponent);
  _Gc[_qp] = _Gc0 / den;
  // below is clearly wrong, so I should fix that... ;)
  _dGc_dv[_qp] = -_Gc0 / den / den;
  _d2Gc_dv2[_qp] = 2 * _Gc0 / den / den / den;
}

// template class InversePowerEnergyReleaseRateTempl<false>;
template class InversePowerEnergyReleaseRateTempl<true>;
