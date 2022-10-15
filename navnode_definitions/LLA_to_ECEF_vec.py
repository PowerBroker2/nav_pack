import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class LLA2ECEFNode(ArmLogicTreeNode):
    bl_idname = 'LNLLA2ECEFNode'
    bl_label  = 'LLA to ECEF'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',  'Planet semi-major axis (m)')
        self.add_input('ArmFloatSocket',  'Planet first eccentricity')
        self.add_input('ArmVectorSocket', 'Vehicle LLA [dd, dd, m]')

        self.add_output('ArmVectorSocket', 'ECEF [m, m, m]', is_var=True)