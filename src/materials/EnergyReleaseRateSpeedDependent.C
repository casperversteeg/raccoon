//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "EnergyReleaseRateSpeedDependent.h"

registerMooseObject("raccoonApp", EnergyReleaseRateSpeedDependent);
registerMooseObject("raccoonApp", ADEnergyReleaseRateSpeedDependent);

template <bool is_ad>
InputParameters
EnergyReleaseRateSpeedDependentTempl<is_ad>::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Compute the critical fracture energy given degradation function, "
                             "local disiipation and mobility");
  params.addRequiredParam<Real>("static_fracture_energy", "Value of Gc when v = 0.");
  params.addRequiredParam<Real>("limiting_crack_speed", "Limiting crack speed.");
  params.addRequiredCoupledVar("v", "Crack speed variable name");
  params.addParam<MaterialPropertyName>(
      "energy_release_rate_name", "energy_release_rate", "Name of the fracture energy");

  return params;
}
template <bool is_ad>
EnergyReleaseRateSpeedDependentTempl<is_ad>::EnergyReleaseRateSpeedDependentTempl(
    const InputParameters & parameters)
  : Material(parameters),
    _v(coupledGenericValue<is_ad>("v")),
    _Gc0(getParam<Real>("static_fracture_energy")),
    _v_lim(getParam<Real>("limiting_crack_speed")),
    _Gc(declareGenericProperty<Real, is_ad>(
        getParam<MaterialPropertyName>("energy_release_rate_name")))
{
}

template <bool is_ad>
void
EnergyReleaseRateSpeedDependentTempl<is_ad>::computeQpProperties()
{
  _Gc[_qp] =
      _Gc0 * (/*std::pow(10, -_v[_qp] / _v_lim)*/ 1 + std::log10(_v_lim / (_v_lim - _v[_qp])));
}

template class EnergyReleaseRateSpeedDependentTempl<false>;
template class EnergyReleaseRateSpeedDependentTempl<true>;
