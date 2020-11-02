// //* This file is part of the RACCOON application
// //* being developed at Dolbow lab at Duke University
// //* http://dolbow.pratt.duke.edu
//
// #include "DeleteBrokenElementUO.h"
// #include <valarray>
//
// registerMooseObject("raccoonApp", DeleteBrokenElementUO);
//
// InputParameters
// DeleteBrokenElementUO::validParams()
// {
//   InputParameters params = ElementUserObject::validParams();
//   params.addClassDescription(
//       "Deletes elements from mesh once they are fully broken (i.e. d = 1 across the element).");
//   params.addRequiredCoupledVar("d", "damage variable");
//   params.addParam<Real>(
//       "d_max", 1, "Maximum value for damage, above which element will be deleted.");
//
//   return params;
// }
//
// DeleteBrokenElementUO::DeleteBrokenElementUO(const InputParameters & parameters)
//   : ElementUserObject(parameters), _d(adCoupledValue("d")), _d_max(getParam<Real>("d_max"))
// {
// }
//
// void
// DeleteBrokenElementUO::execute()
// {
//   std::valarray<ADReal> v(_qrule->n_points());
//   for (unsigned qp = 0; qp < _qrule->n_points(); ++qp)
//   {
//     v[qp] = _d[qp];
//   }
//   if (v.min() >= _d_max)
//   {
//     _mesh._boundary_info->remove(_current_elem);
//     _mesh.getMesh().delete_elem(_current_elem);
//     _mesh.meshChanged();
//     _mesh.needsPrepareForUse();
//   }
// }
