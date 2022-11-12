import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class NED2ENUNode(ArmLogicTreeNode):
    bl_idname = 'LNNED2ENUNode'
    bl_label  = 'NED to ENU Vector'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmVectorSocket', 'NED [m, m, m]')

        self.add_output('ArmVectorSocket', 'ENU [m, m, m]', is_var=True)
        