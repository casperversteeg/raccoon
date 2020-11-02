//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADKernelValue.h"
#include "DerivativeMaterialPropertyNameInterface.h"

class ADDynamicPFFGradientTimeDerivative : public ADKernelValue,
                                           public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  ADDynamicPFFGradientTimeDerivative(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;

  // Time derivative of damage gradient
  const VariableGradient & _grad_d_dot;

  /// Crack tip speed
  const MaterialPropertyName & _v_name;
  bool _lag_v;
  const ADMaterialProperty<Real> * _crack_speed;
  const MaterialProperty<Real> * _crack_speed_old;

  // interface coefficient and derivative of mobility w.r.t. crack speed
  const ADMaterialProperty<Real> & _kappa;
  const ADMaterialProperty<Real> & _dM;
  // crack inertia
  const ADMaterialProperty<Real> & _inertia;
  // dissipation modulus
  const ADMaterialProperty<Real> & _dissipation;
};
