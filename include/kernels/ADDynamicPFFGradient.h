//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADKernelValue.h"
#include "DerivativeMaterialPropertyNameInterface.h"
#include "Function.h"

class ADDynamicPFFGradient : public ADKernelValue, public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  ADDynamicPFFGradient(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;

  // Time derivative of damage
  const ADVariableValue & _d_dot;
  const VariableGradient & _grad_d_dot;
  // Energy release rate, and its derivative
  const ADMaterialProperty<Real> & _Gc;
  const ADMaterialProperty<Real> & _d2Gc_dv2;
  // Phase field regularization length
  const ADMaterialProperty<Real> & _ell;
  // Local dissipation and its norm
  const ADMaterialProperty<Real> & _w;
  const Function & _w_norm;
};
