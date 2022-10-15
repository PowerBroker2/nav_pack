import bpy
from bpy.props import *
from bpy.types import Node, NodeSocket

from arm.logicnode.arm_nodes import *

import navnode_definitions


class ECEF2LLANode(ArmLogicTreeNode):
    bl_idname = 'LNECEF2LLANode'
    bl_label  = 'ECEF to LLA'

    arm_category = navnode_definitions.CATEGORY_NAME
    arm_section  = 'transform'
    arm_version  = 1

    def arm_init(self, context):
        self.add_input('ArmFloatSocket',  'Planet semi-major axis (m)')
        self.add_input('ArmFloatSocket',  'Planet semi-minor axis (m)')
        self.add_input('ArmFloatSocket',  'Planet flattening')
        self.add_input('ArmFloatSocket',  'Planet first eccentricity')
        self.add_input('ArmFloatSocket',  'Planet second eccentricity')
        self.add_input('ArmVectorSocket', 'Vehicle ECEF [m, m, m]')

        self.add_output('ArmVectorSocket', 'Vehicle LLA [dd, dd, m]', is_var=True)