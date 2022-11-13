import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class DragNode(ArmLogicTreeNode):
    bl_idname = 'LNDragNode'
    bl_label  = 'Drag'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'aerodynamics'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket', 'Density (kg/m^3)')
        self.add_input('ArmFloatSocket', 'Velocity (m/s)')
        self.add_input('ArmFloatSocket', 'Ref Area (m^2)')
        self.add_input('ArmFloatSocket', 'Cl')

        self.add_output('ArmFloatSocket', 'Drag (N)', is_var=True)