//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Function.h"

class SmoothStep : public Function
{
public:
  static InputParameters validParams();

  SmoothStep(const InputParameters & parameters);

  virtual Real value(Real t, const Point & p) const override;
  virtual Real timeDerivative(Real t, const Point & p) const override;

protected:
  unsigned n_choose_k(const unsigned n, const unsigned k) const
  {
    return factorial(n) / (factorial(k) * factorial(n - k));
  }
  unsigned factorial(const unsigned n) const
  {
    if (n == 0)
      return 1;
    return n * factorial(n - 1);
  }

  const Real & _t_end;
  const Real & _t_offset;
  const Real & _y_end;
  const unsigned _N;
};
