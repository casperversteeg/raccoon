//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "DynamicFractureMaterial.h"
#include "metaphysicl/raw_type.h"
#include "libmesh/tensor_tools.h"
#include "libmesh/libmesh_common.h"

// registerMooseObject("raccoonApp", DynamicFractureMaterial);
registerADMooseObject("raccoonApp", ADDynamicFractureMaterial);

template <bool is_ad>
InputParameters
DynamicFractureMaterialTempl<is_ad>::validParams()
{
  InputParameters params = FractureMaterialTempl<is_ad>::validParams();
  params.addClassDescription(
      "Compute interface coefficient kappa and mobility for a damage field based on provided "
      "energy release rate Gc and crack length scale L");
  params.addRequiredCoupledVar("d", "damage variable");
  params.addParam<MaterialPropertyName>(
      "crack_surface_density_name",
      "gamma",
      "Name of material property holding the crack surface density");
  params.addParam<MaterialPropertyName>(
      "crack_surface_density_dot_name",
      "gamma",
      "Name of material property holding the crack surface density time derivative");
  params.addParam<MaterialPropertyName>(
      "energy_release_rate_name", "energy_release_rate", "Name of material property holding Gc");
  params.addParam<MaterialPropertyName>(
      "inertia_name", "crack_inertia", "name of the material that holds the crack inertia");
  params.addParam<MaterialPropertyName>(
      "crack_speed_name", "crack_speed", "name of the material that holds the crack tip speed");
  params.addParam<MaterialPropertyName>("dissipation_modulus_name",
                                        "dissipation_modulus",
                                        "name of the material that holds the dissipation modulus");

  params.set<bool>("constant_in_time") = false;

  return params;
}

template <bool is_ad>
DynamicFractureMaterialTempl<is_ad>::DynamicFractureMaterialTempl(
    const InputParameters & parameters)
  : FractureMaterialTempl<is_ad>(parameters),
    _v_name(getParam<MaterialPropertyName>("crack_speed_name")),
    _grad_d(coupledGenericGradient<is_ad>("d")),
    _gamma(getADMaterialProperty<Real>("crack_surface_density_name")),
    _gamma_dot(getADMaterialProperty<Real>("crack_surface_density_dot_name")),
    _Gc(getADMaterialProperty<Real>("energy_release_rate_name")),
    _dGc_dv(getADMaterialProperty<Real>(derivativePropertyNameFirst(
        getParam<MaterialPropertyName>("energy_release_rate_name"), _v_name))),
    _d2Gc_dv2(getADMaterialProperty<Real>(derivativePropertyNameSecond(
        getParam<MaterialPropertyName>("energy_release_rate_name"), _v_name, _v_name))),
    _dM_dv(declareGenericProperty<Real, is_ad>(
        derivativePropertyNameFirst(getParam<MaterialPropertyName>("mobility_name"), _v_name))),
    _damage_inertia(
        declareGenericProperty<Real, is_ad>(getParam<MaterialPropertyName>("inertia_name"))),
    _dissipation(declareGenericProperty<Real, is_ad>(
        getParam<MaterialPropertyName>("dissipation_modulus_name")))
{
}

template <bool is_ad>
void
DynamicFractureMaterialTempl<is_ad>::initQpStatefulProperties()
{
  FractureMaterialTempl<is_ad>::initQpStatefulProperties();
  if (_grad_d[_qp].norm() > 5.0)
  {
    _damage_inertia[_qp] = _gamma[_qp] * _d2Gc_dv2[_qp] / _grad_d[_qp].norm_sq();
    _dissipation[_qp] =
        _gamma_dot[_qp] * _Gc[_qp] *
        (1 + _gamma_dot[_qp]); // _gamma[_qp] * _dGc_dv[_qp] / _grad_d[_qp].norm_sq();
  }
  else
  {
    _damage_inertia[_qp] = 0.0;
    _dissipation[_qp] = 0.0;
  }
}

template <bool is_ad>
void
DynamicFractureMaterialTempl<is_ad>::computeQpProperties()
{
  FractureMaterialTempl<is_ad>::computeQpProperties();
  Real c0 = _w_norm.value(_t, _q_point[_qp]);

  _dM_dv[_qp] = _dGc_dv[_qp] / c0 / _L[_qp];
  if (_grad_d[_qp].norm() > 5.0)
  {
    _damage_inertia[_qp] = _gamma[_qp] * _d2Gc_dv2[_qp] / _grad_d[_qp].norm_sq();
    _dissipation[_qp] =
        _gamma_dot[_qp] * _Gc[_qp] *
        (1 + _gamma_dot[_qp]); //_gamma[_qp] * _dGc_dv[_qp] / _grad_d[_qp].norm_sq();
  }
  else
  {
    _damage_inertia[_qp] = 0.0;
    _dissipation[_qp] = 0.0;
  }
}

// template class DynamicFractureMaterialTempl<false>;
template class DynamicFractureMaterialTempl<true>;
