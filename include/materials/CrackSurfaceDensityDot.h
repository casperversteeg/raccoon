//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "CrackSurfaceDensity.h"
#include "DerivativeMaterialPropertyNameInterface.h"

class CrackSurfaceDensityDot : public CrackSurfaceDensity,
                               public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  CrackSurfaceDensityDot(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  /// crack surface density dot
  ADMaterialProperty<Real> & _gamma_dot;

  const ADVariableValue & _d_dot;
  // const ADVariableSecond & _lap_d;
  const VariableGradient & _grad_d_dot;

  /// local dissipation function
  const ADMaterialProperty<Real> & _dw_dd;
};
