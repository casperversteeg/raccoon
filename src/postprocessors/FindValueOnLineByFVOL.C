//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#include "FindValueOnLineByFVOL.h"

registerMooseObject("raccoonApp", FindValueOnLineByFVOL);

defineLegacyParams(FindValueOnLineByFVOL);

InputParameters
FindValueOnLineByFVOL::validParams()
{
  InputParameters params = FindValueOnLine::validParams();
  params.addClassDescription(
      "We use the same bisection method as the FindValueOnLine postprocessor, but then instead of "
      "returning the position where the target was found, we return the value of a coupled "
      "variable $w$ at that point.");
  params.addCoupledVar("w", "Variable whose value to return at the position where v is found.");
  return params;
}

FindValueOnLineByFVOL::FindValueOnLineByFVOL(const InputParameters & parameters)
  : FindValueOnLine(parameters), _coupled_var_w(*getVar("w", 0)), _val(0.0)
{
}

void
FindValueOnLineByFVOL::execute()
{
  Real s;
  Real s_left = 0.0;
  Real left = getValueAtPoint(_start_point);
  Real s_right = 1.0;
  Real right = getValueAtPoint(_end_point);

  /**
   * Here we determine the direction of the solution. i.e. the left might be the high value
   * while the right might be the low value.
   */
  bool left_to_right = left < right;
  // Initial bounds check
  if ((left_to_right && _target < left) || (!left_to_right && _target < right))
  {
    if (_error_if_not_found)
    {
      mooseError("Target value \"",
                 _target,
                 "\" is less than the minimum sampled value \"",
                 std::min(left, right),
                 "\"");
    }
    else
    {
      _position = _default_value;
      return;
    }
  }
  if ((left_to_right && _target > right) || (!left_to_right && _target > left))
  {
    if (_error_if_not_found)
    {
      mooseError("Target value \"",
                 _target,
                 "\" is greater than the maximum sampled value \"",
                 std::max(left, right),
                 "\"");
    }
    else
    {
      _position = _default_value;
      return;
    }
  }

  bool found_it = false;
  Real value = 0;
  Point p;
  for (unsigned int i = 0; i < _depth; ++i)
  {
    // find midpoint
    s = (s_left + s_right) / 2.0;
    p = s * (_end_point - _start_point) + _start_point;

    // sample value
    value = getValueAtPoint(p);

    // have we hit the target value yet?
    if (MooseUtils::absoluteFuzzyEqual(value, _target, _tol))
    {
      found_it = true;
      break;
    }

    // bisect
    if ((left_to_right && _target < value) || (!left_to_right && _target > value))
      // to the left
      s_right = s;
    else
      // to the right
      s_left = s;
  }

  // Return error if target value (within tol) was not found within depth bisections
  if (!found_it)
    mooseError("Target value \"",
               std::setprecision(10),
               _target,
               "\" not found on line within tolerance, last sample: ",
               value,
               ".");

  _val = getOtherValueAtPoint(p);
}

Real
FindValueOnLineByFVOL::getOtherValueAtPoint(const Point & p)
{
  const Elem * elem = (*_pl)(p);

  processor_id_type elem_proc_id = elem ? elem->processor_id() : DofObject::invalid_processor_id;
  _communicator.min(elem_proc_id);

  if (elem_proc_id == DofObject::invalid_processor_id)
  {
    // there is no element
    mooseError("No element found at the current search point. Please make sure the sampling line "
               "stays inside the mesh completely.");
  }

  Real value = 0;

  if (elem)
  {
    if (elem->processor_id() == processor_id())
    {
      // element is local
      _point_vec[0] = p;
      _subproblem.reinitElemPhys(elem, _point_vec, 0);
      value = _coupled_var_w.sln()[0];
    }
  }

  // broadcast value
  _communicator.broadcast(value, elem_proc_id);
  return value;
}

PostprocessorValue
FindValueOnLineByFVOL::getValue()
{
  return _val;
}
