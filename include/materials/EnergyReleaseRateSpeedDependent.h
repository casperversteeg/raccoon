//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Material.h"

template <bool is_ad>
class EnergyReleaseRateSpeedDependentTempl : public Material
{
public:
  static InputParameters validParams();

  EnergyReleaseRateSpeedDependentTempl(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  const GenericVariableValue<is_ad> & _v;
  const Real & _Gc0;
  const Real & _v_lim;

  /// computed fracture energy release rate
  GenericMaterialProperty<Real, is_ad> & _Gc;
};

typedef EnergyReleaseRateSpeedDependentTempl<false> EnergyReleaseRateSpeedDependent;
typedef EnergyReleaseRateSpeedDependentTempl<true> ADEnergyReleaseRateSpeedDependent;
