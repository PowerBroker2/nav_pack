import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class World2DAENode(ArmLogicTreeNode):
    bl_idname = 'LNWorld2DAENode'
    bl_label  = 'World to DAE'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmVectorSocket', 'World Location [m, m, m]')
        
        self.add_output('ArmFloatSocket', 'Arc Distance (m)', is_var=True)
        self.add_output('ArmFloatSocket', 'Azimuth (°)',      is_var=True)
        self.add_output('ArmFloatSocket', 'Elevation (°)',    is_var=True)