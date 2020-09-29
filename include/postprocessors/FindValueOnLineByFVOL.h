//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "FindValueOnLine.h"

class FindValueOnLineByFVOL;

template <>
InputParameters validParams<FindValueOnLineByFVOL>();

/**
 * I basically want to use the FindValueOnLine postprocessor to find a location,
 * and then extract the value of a different variable at that same location
 * also.
 */

class FindValueOnLineByFVOL : public FindValueOnLine
{
public:
  static InputParameters validParams();

  FindValueOnLineByFVOL(const InputParameters & parameters);

  virtual void execute() override;

  virtual PostprocessorValue getValue() override;

protected:
  Real getOtherValueAtPoint(const Point & p);

  MooseVariable & _coupled_var_w;
  Real _val;
};
