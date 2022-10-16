import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class LDAE2LLANode(ArmLogicTreeNode):
    bl_idname = 'LNLDAE2LLANode'
    bl_label  = 'LDAE to LLA'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',  'Planet semi-major axis (m)')
        self.add_input('ArmFloatSocket',  'Planet first eccentricity')
        self.add_input('ArmVectorSocket', 'Reference LLA [dd, dd, m]')
        self.add_input('ArmFloatSocket',  'Arc Distance (m)')
        self.add_input('ArmFloatSocket',  'Azimuth (°)')
        self.add_input('ArmFloatSocket',  'Elevation (°)')

        self.add_output('ArmVectorSocket', 'LLA [dd, dd, m]', is_var=True)