//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ConstantEnergyReleaseRate.h"
#include "metaphysicl/raw_type.h"

// registerMooseObject("raccoonApp", ConstantnergyReleaseRate);
registerMooseObject("raccoonApp", ADConstantEnergyReleaseRate);

template <bool is_ad>
InputParameters
ConstantEnergyReleaseRateTempl<is_ad>::validParams()
{
  InputParameters params = EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams();
  return params;
}
template <bool is_ad>
ConstantEnergyReleaseRateTempl<is_ad>::ConstantEnergyReleaseRateTempl(
    const InputParameters & parameters)
  : EnergyReleaseRateSpeedDependentBaseTempl<is_ad>(parameters)
{
}

template <bool is_ad>
void
ConstantEnergyReleaseRateTempl<is_ad>::computeGc()
{
  _Gc[_qp] = _Gc0;
  _dGc_dv[_qp] = 0.0;
  _d2Gc_dv2[_qp] = 0.0;
}

// template class ConstantEnergyReleaseRateTempl<false>;
template class ConstantEnergyReleaseRateTempl<true>;
