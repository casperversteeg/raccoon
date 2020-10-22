//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Material.h"
#include "DerivativeMaterialPropertyNameInterface.h"

template <bool is_ad>
class EnergyReleaseRateSpeedDependentTempl : public Material,
                                             public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  EnergyReleaseRateSpeedDependentTempl(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties() override;
  virtual void computeQpProperties() override;

  const GenericVariableValue<is_ad> & _v;
  // const ADVariableValue & _d_dot;
  // const ADVariableGradient & _grad_d;
  const Real & _Gc0;
  const Real & _v_lim;

  /// computed fracture energy release rate
  GenericMaterialProperty<Real, is_ad> & _Gc;
  GenericMaterialProperty<Real, is_ad> & _dGc_dv;
  GenericMaterialProperty<Real, is_ad> & _d2Gc_dv2;

  /// Old Gc
  const MaterialProperty<Real> & _Gc_old;
};

typedef EnergyReleaseRateSpeedDependentTempl<false> EnergyReleaseRateSpeedDependent;
typedef EnergyReleaseRateSpeedDependentTempl<true> ADEnergyReleaseRateSpeedDependent;
