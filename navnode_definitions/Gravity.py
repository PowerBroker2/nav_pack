import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class GravityNode(ArmLogicTreeNode):
    bl_idname = 'LNGravityNode'
    bl_label  = 'Gravity'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',  'Planet Mass (kg)')
        self.add_input('ArmFloatSocket',  'Vehicle Mass (kg)')
        self.add_input('ArmVectorSocket', 'Vehicle ECEF [m, m, m]')

        self.add_output('ArmVectorSocket', 'Gravity [N, N, N] (ECEF Frame)', is_var=True)
        