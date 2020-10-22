//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "CrackVelocityAux.h"
#include "metaphysicl/raw_type.h"

registerMooseObject("raccoonApp", CrackVelocityAux);
registerMooseObject("raccoonApp", ADCrackVelocityAux);

template <bool is_ad>
InputParameters
CrackVelocityAuxTempl<is_ad>::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("Computes the crack velocity as $v = \\dot{d}/\\grad d.");
  params.addRequiredCoupledVar("d", "variable to read the value from");
  return params;
}

template <bool is_ad>
CrackVelocityAuxTempl<is_ad>::CrackVelocityAuxTempl(const InputParameters & parameters)
  : AuxKernel(parameters), _d_dot(adCoupledDot("d")), _grad_d(adCoupledGradient("d"))
{
}

template <bool is_ad>
Real
CrackVelocityAuxTempl<is_ad>::computeValue()
{
  if (_grad_d[_qp].norm() > 0.0 && _d_dot[_qp] > 0.0)
    return MetaPhysicL::raw_value(_d_dot[_qp] / _grad_d[_qp].norm());
  else
    return 0.0;
}

template class CrackVelocityAuxTempl<false>;
template class CrackVelocityAuxTempl<true>;
