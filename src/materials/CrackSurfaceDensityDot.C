//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "CrackSurfaceDensityDot.h"

registerADMooseObject("raccoonApp", CrackSurfaceDensityDot);

InputParameters
CrackSurfaceDensityDot::validParams()
{
  InputParameters params = CrackSurfaceDensity::validParams();
  params.addClassDescription(
      "computes the rate of change of the crack surface density as a function of damage");
  params.addParam<MaterialPropertyName>(
      "crack_surface_density_dot_name",
      "gamma_dot",
      "name of the material to store the crack surface density rate of change");

  return params;
}

CrackSurfaceDensityDot::CrackSurfaceDensityDot(const InputParameters & parameters)
  : CrackSurfaceDensity(parameters),
    _gamma_dot(
        declareADProperty<Real>(getParam<MaterialPropertyName>("crack_surface_density_dot_name"))),
    _d_dot(adCoupledDot("d")),
    // _lap_d(this->getVar("d", 0)->adSecondSln()),
    _grad_d_dot(adCoupledGradientDot("d")),
    _dw_dd(getADMaterialProperty<Real>(derivativePropertyNameFirst(
        getParam<MaterialPropertyName>("local_dissipation_name"), this->getVar("d", 0)->name())))
{
}

void
CrackSurfaceDensityDot::computeQpProperties()
{
  CrackSurfaceDensity::computeQpProperties();
  Real c0 = _c0.value(_t, _q_point[_qp]);
  _gamma_dot[_qp] = _dw_dd[_qp] / c0 / _L[_qp] * _d_dot[_qp] +
                    2 * _L[_qp] / c0 * (_grad_d[_qp] * _grad_d_dot[_qp]);
}
