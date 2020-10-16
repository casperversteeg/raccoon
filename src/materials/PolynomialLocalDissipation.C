//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "PolynomialLocalDissipation.h"

registerADMooseObject("raccoonApp", PolynomialLocalDissipation);

template <bool is_ad>
InputParameters
PolynomialLocalDissipationTempl<is_ad>::validParams()
{
  InputParameters params = Material::validParams();
  params.addClassDescription(
      "computes the local dissipation function as a general polynomial of $d$");
  params.addRequiredCoupledVar("d", "phase-field damage variable");
  params.addParam<MaterialPropertyName>(
      "local_dissipation_name", "w", "name of the material that holds the local dissipation");
  params.addRequiredParam<std::vector<Real>>(
      "coefficients",
      "The list of coefficients for the polynomial $w(d)$ in ascending order (i.e. constant, "
      "linear, quadratic, cubic, etc...)");
  return params;
}

template <bool is_ad>
PolynomialLocalDissipationTempl<is_ad>::PolynomialLocalDissipationTempl(
    const InputParameters & parameters)
  : Material(parameters),
    _d(coupledGenericValue<is_ad>("d")),
    _coefs(getParam<std::vector<Real>>("coefficients")),
    _w_name(getParam<MaterialPropertyName>("local_dissipation_name")),
    _w(declareGenericProperty<Real, is_ad>(_w_name)),
    _dw_dd(declareGenericProperty<Real, is_ad>(
        derivativePropertyNameFirst(_w_name, this->getVar("d", 0)->name())))
{
}

template <bool is_ad>
void
PolynomialLocalDissipationTempl<is_ad>::computeQpProperties()
{
  _w[_qp] = 0.0;
  _dw_dd[_qp] = 0.0;
  for (unsigned i = 0; i < _coefs.size(); ++i)
  {
    _w[_qp] += _coefs[i];
    _w[_qp] *= _d[_qp];
    switch (i)
    {
      case 0:
        break;
      case 1:
        _dw_dd[_qp] += _coefs[i];
        break;
      default:
        _dw_dd[_qp] += _coefs[i];
        _dw_dd[_qp] *= _d[_qp];
        break;
    }
  }
}

// template class PolynomialLocalDissipationTempl<false>;
template class PolynomialLocalDissipationTempl<true>;
