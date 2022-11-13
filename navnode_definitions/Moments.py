import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class MomentsNode(ArmLogicTreeNode):
    bl_idname = 'LNMomentsNode'
    bl_label  = 'Moments'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'aerodynamics'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',  'Density (kg/m^3)')
        self.add_input('ArmFloatSocket',  'Velocity (m/s)')
        self.add_input('ArmFloatSocket',  'Ref Area (m^2)')
        self.add_input('ArmVectorSocket', 'CM')

        self.add_output('ArmVectorSocket', 'Moments [Nm, Nm, Nm]', is_var=True)