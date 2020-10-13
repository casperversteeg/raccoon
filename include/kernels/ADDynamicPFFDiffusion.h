//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADKernelGrad.h"
#include "DerivativeMaterialPropertyNameInterface.h"
#include "Function.h"

class ADDynamicPFFDiffusion : public ADKernelGrad, public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  ADDynamicPFFDiffusion(const InputParameters & parameters);

protected:
  virtual ADRealVectorValue precomputeQpResidual() override;

  // Time derivative of damage
  const ADVariableValue & _d_dot;
  // Energy release rate, and its derivative
  const ADMaterialProperty<Real> & _Gc;
  const ADMaterialProperty<Real> & _dGc_dv;
  // Phase field regularization length
  const ADMaterialProperty<Real> & _ell;
  // Local dissipation and its norm
  const ADMaterialProperty<Real> & _w;
  const Function & _w_norm;
};
