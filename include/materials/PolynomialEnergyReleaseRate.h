//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "EnergyReleaseRateSpeedDependentBase.h"

template <bool is_ad>
class PolynomialEnergyReleaseRateTempl : public EnergyReleaseRateSpeedDependentBaseTempl<true>
{
public:
  static InputParameters validParams();

  PolynomialEnergyReleaseRateTempl(const InputParameters & parameters);

protected:
  virtual void computeGc() override;
  const Real & _exponent;
};

// typedef PolynomialEnergyReleaseRateTempl<false> PolynomialEnergyReleaseRate;
typedef PolynomialEnergyReleaseRateTempl<true> ADPolynomialEnergyReleaseRate;
