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
  if (_coefs.size() < 1)
    mooseError(
        "List of coefficients in PolynomialLocalDissipation must have length greater than 0");
}

template <bool is_ad>
void
PolynomialLocalDissipationTempl<is_ad>::computeQpProperties()
{
  _w[_qp] = _coefs[0];
  _dw_dd[_qp] = 0.0;
  for (unsigned i = 1; i < _coefs.size(); ++i)
  {
    _w[_qp] += _coefs[i] * std::pow(_d[_qp], i);
    if (i == 1)
    {
      _dw_dd[_qp] += _coefs[i];
    }
    else
    {
      _dw_dd[_qp] += i * _coefs[i] * std::pow(_d[_qp], i - 1.0);
    }
  }
  // _w[_qp] = 2 * _d[_qp] - _d[_qp] * _d[_qp];
  // _dw_dd[_qp] = 2 - 2 * _d[_qp];
}

// template class PolynomialLocalDissipationTempl<false>;
template class PolynomialLocalDissipationTempl<true>;
