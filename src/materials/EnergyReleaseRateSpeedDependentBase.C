//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "EnergyReleaseRateSpeedDependentBase.h"
#include "metaphysicl/raw_type.h"
#include "libmesh/libmesh_common.h"

// registerMooseObject("raccoonApp", EnergyReleaseRateSpeedDependentBase);
// registerMooseObject("raccoonApp", ADEnergyReleaseRateSpeedDependentBase);

template <bool is_ad>
InputParameters
EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription("Compute the critical fracture energy given degradation function, "
                             "local disiipation and mobility");
  params.addRequiredParam<Real>("static_fracture_energy", "Value of Gc when v = 0.");
  params.addRequiredParam<Real>("limiting_crack_speed", "Limiting crack speed.");
  params.addParam<Real>(
      "damage_threshold_lower",
      0.0,
      "Lower bound on the damage value, above which the crack speed will be computed.");
  params.addParam<Real>(
      "damage_threshold_upper",
      1.0,
      "Lower bound on the damage value, above which the crack speed will be computed.");
  // params.addRequiredCoupledVar("v", "Crack speed variable name");
  params.addRequiredCoupledVar("d", "damage variable");
  params.addParam<MaterialPropertyName>(
      "energy_release_rate_name", "energy_release_rate", "Name of the fracture energy");
  params.addParam<MaterialPropertyName>(
      "crack_speed_name", "crack_speed", "Name of the crack tip speed material");
  params.addParam<bool>("lag_crack_speed",
                        false,
                        "Whether to use the crack speed from the previous step in this solve");
  return params;
}
template <bool is_ad>
EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::EnergyReleaseRateSpeedDependentBaseTempl(
    const InputParameters & parameters)
  : Material(parameters),
    _lag_v(getParam<bool>("lag_crack_speed")),
    _v_name(getParam<MaterialPropertyName>("crack_speed_name")),
    _d(adCoupledValue("d")),
    _d_dot(adCoupledDot("d")),
    _grad_d(adCoupledGradient("d")),
    _v(declareADProperty<Real>(_v_name)),
    _v_old(_lag_v ? &getMaterialPropertyOld<Real>(_v_name) : nullptr),
    _Gc0(getParam<Real>("static_fracture_energy")),
    _v_lim(getParam<Real>("limiting_crack_speed")),
    _d_thres_lower(getParam<Real>("damage_threshold_lower")),
    _d_thres_upper(getParam<Real>("damage_threshold_upper")),
    _Gc(declareGenericProperty<Real, is_ad>(
        getParam<MaterialPropertyName>("energy_release_rate_name"))),
    _dGc_dv(declareGenericProperty<Real, is_ad>(derivativePropertyNameFirst(
        getParam<MaterialPropertyName>("energy_release_rate_name"), _v_name))),
    _d2Gc_dv2(declareGenericProperty<Real, is_ad>(derivativePropertyNameSecond(
        getParam<MaterialPropertyName>("energy_release_rate_name"), _v_name, _v_name)))
{
}

template <bool is_ad>
void
EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::initQpStatefulProperties()
{
  _v[_qp] = 0.0;
  if (_d[_qp] > _d_thres_lower && _d[_qp] < _d_thres_upper)
  {
    if (_grad_d[_qp].norm() > TOLERANCE)
    {
      _v[_qp] = _d_dot[_qp] / _grad_d[_qp].norm();
    }
  }
  computeGc();
}

template <bool is_ad>
void
EnergyReleaseRateSpeedDependentBaseTempl<is_ad>::computeQpProperties()
{
  _v[_qp] = 0.0;
  if (_d[_qp] > _d_thres_lower && _d[_qp] < _d_thres_upper)
  {
    if (_grad_d[_qp].norm() > TOLERANCE)
    {
      _v[_qp] = _d_dot[_qp] / _grad_d[_qp].norm();
    }
  }
  computeGc();
  // if (_v[_qp] < _v_lim)
  // {
  //   _Gc[_qp] = _Gc0 / (1 - (_v[_qp] / _v_lim));
  //   _dGc_dv[_qp] = 0.0;
  //   _d2Gc_dv2[_qp] = 0.0; // 2.0 * _Gc0 / _v_lim / _v_lim;
  //   // if (_Gc[_qp] < _Gc_old[_qp])
  //   // {
  //   //   _Gc[_qp] = _Gc_old[_qp];
  //   // }
  // }
  // else
  // {
  //   _Gc[_qp] = _Gc_old[_qp];
  //   _dGc_dv[_qp] = std::numeric_limits<Real>::max();
  //   _d2Gc_dv2[_qp] = std::numeric_limits<Real>::max();
  // }
}

template class EnergyReleaseRateSpeedDependentBaseTempl<false>;
template class EnergyReleaseRateSpeedDependentBaseTempl<true>;
