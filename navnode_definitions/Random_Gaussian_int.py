import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class RandomGaussianIntNode(ArmLogicTreeNode):
    bl_idname = 'LNRandomGaussianIntNode'
    bl_label  = 'Random Gaussian Int'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'Random'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket', 'Mean', default_value=1)
        self.add_input('ArmFloatSocket', 'Std',  default_value=1)

        self.add_output('ArmIntSocket', 'Output', is_var=True)