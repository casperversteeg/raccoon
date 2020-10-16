//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "Material.h"
#include "DerivativeMaterialPropertyNameInterface.h"

template <bool is_ad>
class PolynomialLocalDissipationTempl : public Material,
                                        public DerivativeMaterialPropertyNameInterface
{
public:
  static InputParameters validParams();

  PolynomialLocalDissipationTempl(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  /// coupled damage variable
  const GenericVariableValue<is_ad> & _d;

  /// Polynomial coefficients
  const std::vector<Real> & _coefs;

  /// name of local dissipation
  const MaterialPropertyName _w_name;

  /// local dissipation
  GenericMaterialProperty<Real, is_ad> & _w;

  /// local dissipation derivative
  GenericMaterialProperty<Real, is_ad> & _dw_dd;
};

// typedef PolynomialLocalDissipationTempl<false> PolynomialLocalDissipation;
typedef PolynomialLocalDissipationTempl<true> PolynomialLocalDissipation;
