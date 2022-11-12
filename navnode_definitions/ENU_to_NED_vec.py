import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class ENU2NEDNode(ArmLogicTreeNode):
    bl_idname = 'LNENU2NEDNode'
    bl_label  = 'ENU to NED Vector'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmVectorSocket', 'ENU [m, m, m]')

        self.add_output('ArmVectorSocket', 'NED [m, m, m]', is_var=True)
        