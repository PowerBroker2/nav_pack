import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class TraceNode(ArmLogicTreeNode):
    bl_idname = 'LNTraceNode'
    bl_label  = 'Trace'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'debug'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmDynamicSocket',    'Input')
        
        self.add_output('ArmNodeSocketAction', 'Out')