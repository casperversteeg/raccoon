//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "EnergyReleaseRateSpeedDependentBase.h"

template <bool is_ad>
class QuadraticEnergyReleaseRateTempl : public EnergyReleaseRateSpeedDependentBaseTempl<true>
{
public:
  static InputParameters validParams();

  QuadraticEnergyReleaseRateTempl(const InputParameters & parameters);

protected:
  virtual void computeGc() override;
};

// typedef QuadraticEnergyReleaseRateTempl<false> QuadraticEnergyReleaseRate;
typedef QuadraticEnergyReleaseRateTempl<true> ADQuadraticEnergyReleaseRate;
