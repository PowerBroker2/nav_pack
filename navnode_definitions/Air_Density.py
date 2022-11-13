import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class AirDensityNode(ArmLogicTreeNode):
    bl_idname = 'LNAirDensityNode'
    bl_label  = 'Air Density'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'aerodynamics'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',     'Alt above MSL (m)')
        self.add_input('ArmNodeSocketArray', 'Alt above MSL Array [m, m, ..., m]')
        self.add_input('ArmNodeSocketArray', 'Density Array [kg/m^3, kg/m^3, ..., kg/m^3]')
        self.add_input('ArmFloatSocket',     'Density Array Length')

        self.add_output('ArmFloatSocket', 'Density (kg/m^3)', is_var=True)