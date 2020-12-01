//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Material.h"
#include "DerivativeMaterialPropertyNameInterface.h"

template <bool is_ad>
class EnergyReleaseRateSpeedDependentBaseTempl : public Material,
                                                 public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  EnergyReleaseRateSpeedDependentBaseTempl(const InputParameters & parameters);

protected:
  // virtual void initQpStatefulProperties() override;
  virtual void computeQpProperties() override;

  virtual void computeGc() = 0;

  const MaterialPropertyName & _v_name;

  const ADVariableValue & _d;
  const ADVariableValue & _d_dot;
  const ADVariableGradient & _grad_d;
  // Crack speed material property
  ADMaterialProperty<Real> & _v;
  const Real & _Gc0;
  const Real & _v_lim;
  const Real & _d_thres_lower;
  const Real & _d_thres_upper;

  /// computed fracture energy release rate
  GenericMaterialProperty<Real, is_ad> & _Gc;
  GenericMaterialProperty<Real, is_ad> & _dGc_dv;
  GenericMaterialProperty<Real, is_ad> & _d2Gc_dv2;

  /// Old Gc
  // const MaterialProperty<Real> & _Gc_old;
};

typedef EnergyReleaseRateSpeedDependentBaseTempl<false> EnergyReleaseRateSpeedDependentBase;
typedef EnergyReleaseRateSpeedDependentBaseTempl<true> ADEnergyReleaseRateSpeedDependentBase;
