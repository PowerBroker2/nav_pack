import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class WebsocketNode(ArmLogicTreeNode):
    bl_idname = 'LNWebsocketNode'
    bl_label  = 'Websocket'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'Network'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmIntSocket',        'Localhost Port')
        
        self.add_output('ArmNodeSocketAction', 'Out')
        self.add_output('ArmDynamicSocket',    'Websocket', is_var=True)