//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "AuxKernel.h"

/**
 * Self auxiliary value
 */
template <bool is_ad>
class ElementMaterialIntegralAuxTempl : public AuxKernel
{
public:
  static InputParameters validParams();

  ElementMaterialIntegralAuxTempl(const InputParameters & parameters);

  virtual void compute() override;

protected:
  virtual Real computeValue() override;

  /// material property to project values from
  const GenericMaterialProperty<Real, is_ad> & _prop;
};

typedef ElementMaterialIntegralAuxTempl<false> ElementMaterialIntegralAux;
typedef ElementMaterialIntegralAuxTempl<true> ADElementMaterialIntegralAux;
