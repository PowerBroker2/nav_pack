import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class CamTrackPtNode(ArmLogicTreeNode):
    bl_idname = 'LNCamTrackPtNode'
    bl_label  = 'Camera Track Point'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'camera'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmVectorSocket', 'Point Location [m, m, m] (NED Frame)')
        self.add_input('ArmVectorSocket', 'Camera Location [m, m, m] (NED Frame)')
        self.add_input('ArmFloatSocket',  'Roll Angle (rad - Body Frame)')

        self.add_output('ArmRotationSocket', 'Camera Orientation', is_var=True)