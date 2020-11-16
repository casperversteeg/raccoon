//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADKernelGrad.h"

class ADDiffusionRate : public ADKernelGrad
{
public:
  static InputParameters validParams();

  ADDiffusionRate(const InputParameters & parameters);

protected:
  virtual ADRealVectorValue precomputeQpResidual() override;

  const ADVariableGradient & _grad_u_dot;
  const Real & _mu;
};
