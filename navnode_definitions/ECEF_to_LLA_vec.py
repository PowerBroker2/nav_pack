import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class ECEF2LLANode(ArmLogicTreeNode):
    """Returns the LLA (Latitude [dd], Longitude [dd], Altitude [m above MSL]) of the given world point."""
    bl_idname = 'LNECEF2LLANode'
    bl_label  = 'ECEF to LLA'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmNodeSocketObject', 'Object')
        self.add_input('ArmVectorSocket',     'ECEF')

        self.add_output('ArmVectorSocket', 'LLA', is_var=True)