import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class NED2ENURotNode(ArmLogicTreeNode):
    bl_idname = 'LNNED2ENURotNode'
    bl_label  = 'NED to ENU rotation'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_output('ArmRotationSocket', 'Rotation', is_var=True)
        