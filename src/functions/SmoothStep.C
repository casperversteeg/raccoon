//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "SmoothStep.h"

registerMooseObject("raccoonApp", SmoothStep);

InputParameters
SmoothStep::validParams()
{
  InputParameters params = Function::validParams();
  params.addClassDescription("2N+1 order polynomial smoothstep");
  params.addParam<Real>("t_end", 1.0, "End time of smoothstep");
  params.addParam<Real>("y_end", 1.0, "Final value of smoothstep");
  params.addParam<unsigned>("N", 1, "Smoothstep order");
  params.addParam<Real>("t_offset", 0.0, "Time delay at start");

  return params;
}

SmoothStep::SmoothStep(const InputParameters & parameters)
  : Function(parameters),
    _t_end(getParam<Real>("t_end")),
    _t_offset(getParam<Real>("t_offset")),
    _y_end(getParam<Real>("y_end")),
    _N(getParam<unsigned>("N"))
{
}

Real
SmoothStep::value(Real t, const Point & /* p*/) const
{
  if ((t - _t_offset) / _t_end <= 0.0)
  {
    return 0.0;
  }
  else if ((t - _t_offset) / _t_end >= 1.0)
  {
    return _y_end;
  }
  else
  {
    Real ans = 0.0;
    for (unsigned n = 0; n <= _N; ++n)
    {
      ans += std::pow(-1, n) * n_choose_k(_N + n, n) * n_choose_k(2 * _N + 1, _N - n) *
             std::pow((t - _t_offset) / _t_end, _N + n + 1);
    }
    return ans;
  }
}

Real
SmoothStep::timeDerivative(Real t, const Point & /*p*/) const
{
  if ((t - _t_offset) / _t_end <= 0.0 || (t - _t_offset) / _t_end >= 1.0)
  {
    return 0.0;
  }
  else
  {
    Real ans = 0.0;
    for (unsigned n = 0; n <= _N; ++n)
    {
      ans += std::pow(-1, n) * (_N + n + 1) / _t_end * n_choose_k(_N + n, n) *
             n_choose_k(2 * _N + 1, _N - n) * std::pow((t - _t_offset) / _t_end, _N + n);
    }
    return ans;
  }
}
