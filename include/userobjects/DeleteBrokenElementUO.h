// //* This file is part of the RACCOON application
// //* being developed at Dolbow lab at Duke University
// //* http://dolbow.pratt.duke.edu
//
// #pragma once
//
// #include "ElementUserObject.h"
//
// class DeleteBrokenElementUO : public ElementUserObject
// {
// public:
//   static InputParameters validParams();
//
//   DeleteBrokenElementUO(const InputParameters & parameters);
//
//   virtual void initialize() override {}
//   virtual void threadJoin(const UserObject & /*y*/) override {}
//   virtual void finalize() override {}
//
// protected:
//   virtual void execute() override;
//
//   const ADVariableValue & _d;
//   const Real & _d_max;
// };
