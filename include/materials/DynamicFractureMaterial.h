//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "FractureMaterial.h"
#include "DerivativeMaterialPropertyNameInterface.h"

template <bool is_ad = true>
class DynamicFractureMaterialTempl : public FractureMaterialTempl<true>,
                                     public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  DynamicFractureMaterialTempl(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties() override;
  virtual void computeQpProperties() override;

  /// Name of crack speed material
  const MaterialPropertyName & _v_name;

  /// Gradient of damage variable
  const GenericVariableGradient<is_ad> & _grad_d;

  /// Crack surface density
  const ADMaterialProperty<Real> & _gamma;
  const ADMaterialProperty<Real> & _gamma_dot;

  /// Fracture energy release rate
  const GenericMaterialProperty<Real, is_ad> & _Gc;
  const GenericMaterialProperty<Real, is_ad> & _dGc_dv;
  const GenericMaterialProperty<Real, is_ad> & _d2Gc_dv2;

  /// Derivative of mobility with respect to crack speed
  GenericMaterialProperty<Real, is_ad> & _dM_dv;

  /// Damage inertia term
  GenericMaterialProperty<Real, is_ad> & _damage_inertia;
  GenericMaterialProperty<Real, is_ad> & _dissipation;
};

// typedef DynamicFractureMaterialTempl<false> DynamicFractureMaterial;
typedef DynamicFractureMaterialTempl<true> ADDynamicFractureMaterial;
