import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class RotVecNode(ArmLogicTreeNode):
    bl_idname = 'LNRotVecNode'
    bl_label  = 'Rotate Vector'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmVectorSocket',   'Input Vector')
        self.add_input('ArmRotationSocket', 'Rotation')

        self.add_output('ArmVectorSocket', 'Output Vector', is_var=True)
        