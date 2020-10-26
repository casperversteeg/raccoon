//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "ADDynamicPFFInertia.h"
#include "metaphysicl/raw_type.h"

registerADMooseObject("raccoonApp", ADDynamicPFFInertia);

InputParameters
ADDynamicPFFInertia::validParams()
{
  InputParameters params = ADInertialForce::validParams();
  params.addClassDescription(
      "Computes time derivative terms in dynamic phase-field evolution equation");
  params.set<MaterialPropertyName>("density") = "crack_inertia";

  return params;
}

ADDynamicPFFInertia::ADDynamicPFFInertia(const InputParameters & parameters)
  : ADInertialForce(parameters)
{
}
