import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class FixedWingNode(ArmLogicTreeNode):
    bl_idname = 'LNFixedWingNode'
    bl_label  = 'Fixed Wing Dynamics'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'aerodynamics'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',    'Air Density (kg/m^3)')
        self.add_input('ArmVectorSocket',   'Gravity_Vector [N, N, N] (NED Frame)')
        self.add_input('ArmFloatSocket',    'Vehicle Mass (kg)')
        self.add_input('ArmVectorSocket',   'Vehicle CG [m, m, m] (Body Frame)')
        self.add_input('ArmVectorSocket',   'Vehicle LLA [dd, dd, m]')
        self.add_input('ArmRotationSocket', 'Vehicle Orientation (Body to NED')
        self.add_input('ArmVectorSocket',   'Vehicle Angular Velocity Vector [°/s, °/s, °/s] (Body Frame)')
        self.add_input('ArmVectorSocket',   'Vehicle Velocity Vector [m/s, m/s, m/s] (Body Frame)')
        self.add_input('ArmVectorSocket',   'Wind Velocity Vector [m/s, m/s, m/s] (NED Frame)')
        self.add_input('ArmVectorSocket',   'Angular Dampening Vector')
        self.add_input('ArmFloatSocket',    'CL Scale')
        self.add_input('ArmFloatSocket',    'CL Offset')
        self.add_input('ArmFloatSocket',    'Cd Scale')
        self.add_input('ArmFloatSocket',    'Cd Offset')
        self.add_input('ArmFloatSocket',    'CFx Scale')
        self.add_input('ArmFloatSocket',    'CFx Offset')
        self.add_input('ArmFloatSocket',    'CFy Scale')
        self.add_input('ArmFloatSocket',    'CFy Offset')
        self.add_input('ArmFloatSocket',    'CFz Scale')
        self.add_input('ArmFloatSocket',    'CFz Offset')
        self.add_input('ArmFloatSocket',    'CMx Scale')
        self.add_input('ArmFloatSocket',    'CMx Offset')
        self.add_input('ArmFloatSocket',    'CMy Scale')
        self.add_input('ArmFloatSocket',    'CMy Offset')
        self.add_input('ArmFloatSocket',    'CMz Scale')
        self.add_input('ArmFloatSocket',    'CMz Offset')
        self.add_input('ArmFloatSocket',    'Ref Airspeed (m/s)')
        self.add_input('ArmFloatSocket',    'Ref Pitch Moment (Nm)')
        self.add_input('ArmFloatSocket',    'Ref Roll Moment (Nm)')
        self.add_input('ArmFloatSocket',    'Ref Yaw Moment (Nm)')
        self.add_input('ArmFloatSocket',    'Pitch Command (0 <-> 1023)')
        self.add_input('ArmFloatSocket',    'Roll Command (0 <-> 1023)')
        self.add_input('ArmFloatSocket',    'Yaw Command (0 <-> 1023)')

        self.add_output('ArmVectorSocket', 'Force Vector [N, N, N] (Body Frame)', is_var=True)
        self.add_output('ArmVectorSocket', 'Moment Vector [Nm, Nm, Nm] (Body Frame)', is_var=True)
        