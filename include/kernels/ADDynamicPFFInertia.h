//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "ADInertialForce.h"

class ADDynamicPFFInertia : public ADInertialForce
{
public:
  static InputParameters validParams();

  ADDynamicPFFInertia(const InputParameters & parameters);

protected:
  // virtual ADReal precomputeQpResidual() override;

  // // Old variable values
  // const VariableValue * _u_old;
  // const VariableValue * _u_dot_old;
  // const VariableValue * _u_dotdot_old;
  // // Time integration parameter
  // const Real & _beta;
  /// crack inertia
  // const ADMaterialProperty<Real> & _inertia;
};
