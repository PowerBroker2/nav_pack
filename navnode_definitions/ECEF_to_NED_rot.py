import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class ECEF2NEDRotNode(ArmLogicTreeNode):
    bl_idname = 'LNECEF2NEDRotNode'
    bl_label  = 'ECEF to NED rotation'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmVectorSocket', 'NED Origin LLA')

        self.add_output('ArmRotationSocket', 'Rotation', is_var=True)
        