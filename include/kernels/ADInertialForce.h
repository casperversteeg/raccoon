//* This file is part of the RACCOON application
//* being developed at Dolbow lab at Duke University
//* http://dolbow.pratt.duke.edu

#pragma once

#include "TimeKernel.h"
#include "Material.h"

// Forward Declarations
class TimeIntegrator;

class ADInertialForce : public TimeKernel
{
public:
  static InputParameters validParams();

  ADInertialForce(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

  virtual void computeResidualAdditional() override;

private:
  const ADMaterialProperty<Real> & _density;
  const VariableValue * _u_old;
  const VariableValue * _vel_old;
  const VariableValue * _accel_old;
  const bool _has_beta;
  const bool _has_gamma;
  const Real _beta;
  const Real _gamma;
  const bool _has_velocity;
  const bool _has_acceleration;
  const ADMaterialProperty<Real> & _eta;
  const Real _alpha;

  // Velocity and acceleration calculated by time integrator
  const VariableValue * _u_dot_factor_dof;
  const VariableValue * _u_dotdot_factor_dof;
  const VariableValue * _u_dot_factor;
  const VariableValue * _u_dotdot_factor;
  const VariableValue * _u_dot_old;
  const VariableValue * _du_dot_du;
  const VariableValue * _du_dotdot_du;

  /// The TimeIntegrator
  TimeIntegrator & _time_integrator;
};
