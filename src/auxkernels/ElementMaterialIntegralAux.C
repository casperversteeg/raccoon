//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ElementMaterialIntegralAux.h"
#include "metaphysicl/raw_type.h"
#include "raccoonAppTypes.h"

registerMooseObject("raccoonApp", ElementMaterialIntegralAux);
registerMooseObject("raccoonApp", ADElementMaterialIntegralAux);

template <bool is_ad>
InputParameters
ElementMaterialIntegralAuxTempl<is_ad>::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("reads a material property into a monomial.");
  params.addRequiredParam<MaterialPropertyName>("property", "material to read the value from");

  return params;
}
template <bool is_ad>
ElementMaterialIntegralAuxTempl<is_ad>::ElementMaterialIntegralAuxTempl(
    const InputParameters & parameters)
  : AuxKernel(parameters), _prop(getGenericMaterialProperty<Real, is_ad>("property"))
{
}

template <bool is_ad>
void
ElementMaterialIntegralAuxTempl<is_ad>::compute()
{
  precalculateValue();

  if (isNodal())
    mooseError("ElementMaterialIntegralAux only makes sense as an Elemental AuxVariable.");

  Real sum = 0;
  for (_qp = 0; _qp < _qrule->n_points(); _qp++)
  {
    sum += _JxW[_qp] * _coord[_qp] * computeValue();
  }

  _var.setNodalValue(sum);
}

template <bool is_ad>
Real
ElementMaterialIntegralAuxTempl<is_ad>::computeValue()
{
  return MetaPhysicL::raw_value(_prop[_qp]);
}

template class ElementMaterialIntegralAuxTempl<false>;
template class ElementMaterialIntegralAuxTempl<true>;
