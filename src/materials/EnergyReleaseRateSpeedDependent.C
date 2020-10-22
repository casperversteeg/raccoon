//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "EnergyReleaseRateSpeedDependent.h"
#include "metaphysicl/raw_type.h"

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
  // params.addRequiredCoupledVar("d", "damage variable");
  params.addParam<MaterialPropertyName>(
      "energy_release_rate_name", "energy_release_rate", "Name of the fracture energy");

  return params;
}
template <bool is_ad>
EnergyReleaseRateSpeedDependentTempl<is_ad>::EnergyReleaseRateSpeedDependentTempl(
    const InputParameters & parameters)
  : Material(parameters),
    // _d_dot(adCoupledDot("d")),
    // _grad_d(adCoupledGradient("d")),
    _v(coupledGenericValue<is_ad>("v")),
    _Gc0(getParam<Real>("static_fracture_energy")),
    _v_lim(getParam<Real>("limiting_crack_speed")),
    _Gc(declareGenericProperty<Real, is_ad>(
        getParam<MaterialPropertyName>("energy_release_rate_name"))),
    _dGc_dv(declareGenericProperty<Real, is_ad>(derivativePropertyNameFirst(
        getParam<MaterialPropertyName>("energy_release_rate_name"), "crack_speed"))),
    _d2Gc_dv2(declareGenericProperty<Real, is_ad>(derivativePropertyNameSecond(
        getParam<MaterialPropertyName>("energy_release_rate_name"), "crack_speed", "crack_speed"))),
    _Gc_old(getMaterialPropertyOld<Real>("energy_release_rate_name"))
{
}

template <bool is_ad>
void
EnergyReleaseRateSpeedDependentTempl<is_ad>::initQpStatefulProperties()
{
  _Gc[_qp] = _Gc0;
}

template <bool is_ad>
void
EnergyReleaseRateSpeedDependentTempl<is_ad>::computeQpProperties()
{
  // Real v = 0.0;
  // if (_grad_d[_qp].norm() > 0.0)
  //   v = MetaPhysicL::raw_value(_d_dot[_qp] / _grad_d[_qp].norm());
  if (_v[_qp] < _v_lim)
  {
    _Gc[_qp] = _Gc0 / (1 - (_v[_qp] / _v_lim));
    _dGc_dv[_qp] = 0.0;
    _d2Gc_dv2[_qp] = 0.0; // 2.0 * _Gc0 / _v_lim / _v_lim;
    // if (_Gc[_qp] < _Gc_old[_qp])
    // {
    //   _Gc[_qp] = _Gc_old[_qp];
    // }
  }
  else
  {
    _Gc[_qp] = _Gc_old[_qp];
    _dGc_dv[_qp] = std::numeric_limits<Real>::max();
    _d2Gc_dv2[_qp] = std::numeric_limits<Real>::max();
  }
}

template class EnergyReleaseRateSpeedDependentTempl<false>;
template class EnergyReleaseRateSpeedDependentTempl<true>;
