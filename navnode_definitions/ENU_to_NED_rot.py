import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class ENU2NEDRotNode(ArmLogicTreeNode):
    bl_idname = 'LNENU2NEDRotNode'
    bl_label  = 'ENU to NED rotation'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_output('ArmRotationSocket', 'Rotation', is_var=True)
        