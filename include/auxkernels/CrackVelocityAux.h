//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "AuxKernel.h"
#include "Function.h"
#include "DerivativeMaterialPropertyNameInterface.h"

/**
 * Self auxiliary value
 */
template <bool is_ad>
class CrackVelocityAuxTempl : public AuxKernel, public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  CrackVelocityAuxTempl(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  /// coupeld variable to read values from
  const ADVariableValue & _d_dot;
  const ADVariableGradient & _grad_d;
};

typedef CrackVelocityAuxTempl<false> CrackVelocityAux;
typedef CrackVelocityAuxTempl<true> ADCrackVelocityAux;
