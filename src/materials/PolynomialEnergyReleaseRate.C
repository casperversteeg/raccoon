//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "PolynomialEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", PolynomialEnergyReleaseRate);
registerMooseObject("raccoonApp", ADPolynomialEnergyReleaseRate);

template <bool is_ad>
InputParameters
PolynomialEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  params.addParam<Real>("exponent", 1.0, "Exponent on the denominator");
  return params;
}
template <bool is_ad>
PolynomialEnergyReleaseRateTempl<is_ad>::PolynomialEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters),
    _exponent(getParam<Real>("exponent"))
{
  if (_exponent <= 2)
    mooseWarning("You will probably want to use the LinearEnergyReleaseRate or "
                 "QuadraticEnergyReleaseRate materials for exponent <= 2");
}

template <bool is_ad>
void
PolynomialEnergyReleaseRateTempl<is_ad>::computeGc()
{
  ADReal v = (_lag_v ? (*_v_old)[_qp] : _v[_qp]);
  _Gc[_qp] = _Gc0 * (1 + std::pow((v / _v_lim), _exponent));
  _dGc_dv[_qp] = _exponent * _Gc0 * std::pow(v / _v_lim, _exponent - 1) / _v_lim;
  _d2Gc_dv2[_qp] =
      _exponent * (_exponent - 1) * _Gc0 * std::pow(_v[_qp] / _v_lim, _exponent - 2) / _v_lim;
}

// template class PolynomialEnergyReleaseRateTempl<false>;
template class PolynomialEnergyReleaseRateTempl<true>;
