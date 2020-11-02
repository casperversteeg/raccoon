//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADPFFDiffusion.h"

class ADDynamicPFFDiffusion : public ADPFFDiffusion
{
public:
  static InputParameters validParams();

  ADDynamicPFFDiffusion(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  // Energy release rate, and its derivative
  bool _lag_v;
  const ADMaterialProperty<Real> * _crack_speed;
  const MaterialProperty<Real> * _crack_speed_old;
  const ADMaterialProperty<Real> & _dissipation;
};
