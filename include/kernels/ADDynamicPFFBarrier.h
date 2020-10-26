//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADPFFBarrier.h"

class ADDynamicPFFBarrier : public ADPFFBarrier
{
public:
  static InputParameters validParams();

  ADDynamicPFFBarrier(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;

  const MaterialPropertyName & _v_name;
  const ADMaterialProperty<Real> & _crack_speed;
  const ADMaterialProperty<Real> & _dM;
};
